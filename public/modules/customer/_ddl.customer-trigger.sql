
-- Trigger untuk memperbarui kolom datatimestamp secara otomatis (dalam UTC) saat ada insert atau update data customer
CREATE OR REPLACE FUNCTION update_customer_datatimestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.datatimestamp = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE OR REPLACE TRIGGER update_customer_timestamp
    BEFORE INSERT OR UPDATE ON public.customer
    FOR EACH ROW
    EXECUTE FUNCTION update_customer_datatimestamp();

-- Trigger untuk memperbarui datatimestamp di tabel customer saat ada perubahan (insert/update/delete) di customerdisc
CREATE OR REPLACE FUNCTION update_customer_timestamp_from_disc()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        IF NEW.customer_id IS NOT NULL THEN
            UPDATE public.customer 
            SET datatimestamp = now()
            WHERE customer_id = NEW.customer_id;
        END IF;
    END IF;
    
    IF TG_OP = 'DELETE' OR TG_OP = 'UPDATE' THEN
        IF OLD.customer_id IS NOT NULL AND (TG_OP = 'DELETE' OR OLD.customer_id <> COALESCE(NEW.customer_id, -1)) THEN
            UPDATE public.customer 
            SET datatimestamp = now()
            WHERE customer_id = OLD.customer_id;
        END IF;
    END IF;
    
    RETURN NULL;
END;
$$ language 'plpgsql';

CREATE OR REPLACE TRIGGER update_customer_timestamp_on_disc_change
    AFTER INSERT OR UPDATE OR DELETE ON public.customerdisc
    FOR EACH ROW
    EXECUTE FUNCTION update_customer_timestamp_from_disc();
