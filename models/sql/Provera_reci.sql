CREATE OR REPLACE FUNCTION proveri_rec()
RETURNS TRIGGER AS $$
begin
    IF exists(select * from neprimenjene_reci where neprimenjene_reci.rec = NEW.sadrzaj) then RAISE EXCEPTION 'Data rec je neprimenjena';
    END IF;
    RETURN NEW;
     
end;
$$LANGUAGE plpgsql;

CREATE TRIGGER proveri_rec_tr
    BEFORE INSERT ON pojam
    FOR EACH ROW EXECUTE PROCEDURE proveri_rec();