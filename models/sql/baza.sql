/**
 * Author:  ivica
 * Created: 27.10.2018.
 */

CREATE TABLE korisnik (
    id serial PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    ime VARCHAR(50) NOT NULL,
    lozinka_hash TEXT,
    aktivan BOOLEAN NOT NULL DEFAULT FALSE,
    reset_kod TEXT NULL,
    auth_key TEXT,
    vreme_registracije timestamptz
);

-- Imutable
-- filtrirati neprimerene reci?
<<<<<<< HEAD
CREATE TABLE pojam(
    id serial PRIMARY KEY,
    kreator_id INT NOT NULL,
    sadrzaj TEXT NOT NULL UNIQUE,
    CONSTRAINT fk_kreator_pojam
        FOREIGN KEY (kreator_id)
        REFERENCES korisnik(id) 
        ON DELETE RESTRICT
);
CREATE INDEX idx_kreator_pojam ON pojam(kreator_id);

-- imutable. Svaki update kreira novu asocijaciju.
CREATE TABLE asocijacija(
    id serial PRIMARY KEY,
    resenje_id INT NOT NULL,
    kreator_id INT NOT NULL,
    -- TODO kreirati triger koji popunjava pojam prilikom inserta
    pojmovi_ids TEXT NOT NULL UNIQUE, -- Prvi id je id resenja. Nakon toga ide zapeta, pa sortirana lista id pojmova odvojena zapetama, 
                                    -- cilj je da se osigura jedinstvenost asocijacije. 
    CONSTRAINT fk_kreator_asocijacija
        FOREIGN KEY (kreator_id)
        REFERENCES korisnik(id) 
        ON DELETE RESTRICT,        
    CONSTRAINT fk_resenje_asocijacija
        FOREIGN KEY (resenje_id)
        REFERENCES pojam(id) 
        ON DELETE RESTRICT
);
CREATE INDEX idx_resenje_asocijacija ON asocijacija(resenje_id);
CREATE INDEX idx_kreator_asocijacija ON asocijacija(kreator_id);

CREATE TABLE asocijacija_pojam(
    asocijacija_id INT NOT NULL,
    pojam_id INT NOT NULL,
    PRIMARY KEY (asocijacija_id, pojam_id),
    CONSTRAINT fk_asocijacija_asocijacija_pojam
        FOREIGN KEY (asocijacija_id)
        REFERENCES asocijacija(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_pojam_asocijacija_pojam
        FOREIGN KEY (pojam_id)
        REFERENCES pojam(id) 
        ON DELETE CASCADE    
);
CREATE INDEX idx_pojam_asocijacija_pojam ON asocijacija_pojam(pojam_id);
=======
create table pojam(
    id serial primary key,
    kreator_id int not null,
    sadrzaj text not null unique,
    constraint fk_kreator_pojam
        foreign key (kreator_id)
        references korisnik(id) 
        on delete restrict
);
create index idx_kreator_pojam on pojam(kreator_id);

-- imutable. Svaki update kreira novu asocijaciju.
create table asocijacija(
    id serial primary key,
    resenje_id int not null,
    kreator_id int not null,
    -- TODO kreirati triger koji popunjava pojam prilikom inserta
    pojmovi_ids text not null unique, -- Prvi id je id resenja. Nakon toga ide zapeta, pa sortirana lista id pojmova odvojena zapetama, 
                                    -- cilj je da se osigura jedinstvenost asocijacije. 
    constraint fk_kreator_asocijacija
        foreign key (kreator_id)
        references korisnik(id) 
        on delete restrict,        
    constraint fk_resenje_asocijacija
        foreign key (resenje_id)
        references pojam(id) 
        on delete restrict
);
create index idx_resenje_asocijacija on asocijacija(resenje_id);
create index idx_kreator_asocijacija on asocijacija(kreator_id);

create table asocijacija_pojam(
    asocijacija_id int not null,
    pojam_id int not null,
    primary key (asocijacija_id, pojam_id),
    constraint fk_asocijacija_asocijacija_pojam
        foreign key (asocijacija_id)
        references asocijacija(id) 
        on delete cascade,
    constraint fk_pojam_asocijacija_pojam
        foreign key (pojam_id)
        references pojam(id) 
        on delete cascade    
);
create index idx_pojam_asocijacija_pojam on asocijacija_pojam(pojam_id);

>>>>>>> 1d12c57e31db0081f5cd1ce20e99ffbff0427999


CREATE TABLE kategorija(
    id serial PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL,
    roditelj_id INT, -- koristi se prilikom rekonstrukcije stabla (vrednosti levo i desno)
    levo INT, -- struktura stabla je definisana preko ugnjezdenih skupova (nested set)
    desno INT,
    CONSTRAINT fk_roditelj_kategorija
        FOREIGN KEY (roditelj_id)
        REFERENCES kategorija(id) 
        ON DELETE CASCADE
);
CREATE INDEX idx_roditelj_kategorija ON kategorija(roditelj_id);

-- igra sadrzi niz asocijacija
<<<<<<< HEAD
CREATE TABLE igra(
    id serial PRIMARY KEY,
    kategorija_id INT NOT NULL,
    kreator_id INT NOT NULL,
    vreme_kreiranja timestamptz NOT NULL,
    naziv VARCHAR(100) NOT NULL,
    opis TEXT,
    aktivna BOOLEAN NOT NULL DEFAULT FALSE,
   -- meta json not null,
    broj_igranja INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_kategorija_igra
        FOREIGN KEY (kategorija_id)
        REFERENCES kategorija(id) 
        ON DELETE RESTRICT,
    CONSTRAINT fk_kreator_igra
        FOREIGN KEY (kreator_id)
        REFERENCES korisnik(id) 
        ON DELETE RESTRICT
);
CREATE INDEX idx_kategorija_igra ON igra(kategorija_id, aktivna);
CREATE INDEX idx_kreator_igra ON igra(kreator_id, aktivna);
CREATE INDEX idx_broj_igranja_igra ON igra(broj_igranja, aktivna);


CREATE TABLE igra_asocijacija(
    igra_id INT NOT NULL,
    asocijacija_id INT NOT NULL,
    PRIMARY KEY(igra_id, asocijacija_id),
    CONSTRAINT fk_igra_igra_asocijacija
        FOREIGN KEY (igra_id)
        REFERENCES igra(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_asocijacija_igra_asocijacija
        FOREIGN KEY (asocijacija_id)
        REFERENCES asocijacija(id) 
        ON DELETE CASCADE
);
CREATE INDEX idx_asocijacija_igra_asocijacija ON igra_asocijacija(asocijacija_id);

CREATE TABLE resena_igra(
    igra_id INT NOT NULL,
    korisnik_id INT NOT NULL,
    PRIMARY KEY(igra_id, korisnik_id),
    CONSTRAINT fk_igra_resena_igra
        FOREIGN KEY (igra_id)
        REFERENCES igra(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_korisnik_resena_igra
        FOREIGN KEY (korisnik_id)
        REFERENCES korisnik(id) 
        ON DELETE RESTRICT
);
CREATE INDEX idx_korisnik_resena_igra ON resena_igra(korisnik_id);

CREATE TABLE resena_asocijacija(
    asocijacija_id INT NOT NULL,
    korisnik_id INT NOT NULL,
    PRIMARY KEY (asocijacija_id, korisnik_id),
    CONSTRAINT fk_asocijacija_resena_asocijacija
        FOREIGN KEY (asocijacija_id)
        REFERENCES asocijacija(id) 
        ON DELETE CASCADE,
    CONSTRAINT fk_korisnik_resena_asocijacija
        FOREIGN KEY (korisnik_id)
        REFERENCES korisnik(id) 
        ON DELETE RESTRICT
);
CREATE INDEX idx_korisnik_resena_asocijacija ON resena_asocijacija(asocijacija_id);

CREATE TABLE IF NOT EXISTS neprimenjene_reci(
    id serial PRIMARY KEY,
    rec TEXT NOT NULL UNIQUE    
);

-- sledeca dva unosa su vezana za neprimenjene reci.
CREATE OR REPLACE FUNCTION sve_u_mala_slova() -- azurira zadnji unos u tabeli neprimenjene_reci u lowercase slova.
 RETURNS TRIGGER AS $$ 
    BEGIN
        UPDATE neprimenjene_reci set rec=lower(rec) where id IN(select max(id) FROM neprimenjene_reci); 
        RETURN NEW;
    END;
  $$ LANGUAGE plpgsql;

CREATE TRIGGER pretvori_u_mala -- dodajemo triger prilikom svakog unosa u tabelu neprimenjene_reci.
        AFTER INSERT ON neprimenjene_reci
        EXECUTE PROCEDURE sve_u_mala_slova();
=======
create table igra(
    id serial primary key,
    kategorija_id int not null,
    kreator_id int not null,
    vreme_kreiranja timestamptz not null,
    naziv varchar(100) not null,
    opis text,
    aktivna boolean not null default false,
    meta json not null,
    broj_igranja int not null default 0,
    constraint fk_kategorija_igra
        foreign key (kategorija_id)
        references kategorija(id) 
        on delete restrict,
    constraint fk_kreator_igra
        foreign key (kreator_id)
        references korisnik(id) 
        on delete restrict
);
create index idx_kategorija_igra on igra(kategorija_id, aktivna);
create index idx_kreator_igra on igra(kreator_id, aktivna);
create index idx_broj_igranja_igra on igra(broj_igranja, aktivna);


create table igra_asocijacija(
    igra_id int not null,
    asocijacija_id int not null,
    primary key(igra_id, asocijacija_id),
    constraint fk_igra_igra_asocijacija
        foreign key (igra_id)
        references igra(id) 
        on delete cascade,
    constraint fk_asocijacija_igra_asocijacija
        foreign key (asocijacija_id)
        references asocijacija(id) 
        on delete cascade
);
create index idx_asocijacija_igra_asocijacija on igra_asocijacija(asocijacija_id);

create table resena_igra(
    igra_id int not null,
    korisnik_id int not null,
    primary key(igra_id, korisnik_id),
    constraint fk_igra_resena_igra
        foreign key (igra_id)
        references igra(id) 
        on delete cascade,
    constraint fk_korisnik_resena_igra
        foreign key (korisnik_id)
        references korisnik(id) 
        on delete restrict
);
create index idx_korisnik_resena_igra on resena_igra(korisnik_id);

create table resena_asocijacija(
    asocijacija_id int not null,
    korisnik_id int not null,
    primary key (asocijacija_id, korisnik_id),
    constraint fk_asocijacija_resena_asocijacija
        foreign key (asocijacija_id)
        references asocijacija(id) 
        on delete cascade,
    constraint fk_korisnik_resena_asocijacija
        foreign key (korisnik_id)
        references korisnik(id) 
        on delete restrict
);
create index idx_korisnik_resena_asocijacija on resena_asocijacija(asocijacija_id);
>>>>>>> 1d12c57e31db0081f5cd1ce20e99ffbff0427999
