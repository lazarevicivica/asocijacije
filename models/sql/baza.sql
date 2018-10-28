/**
 * Author:  ivica
 * Created: 27.10.2018.
 */

create table korisnik (
    id serial primary key,
    email text not null unique,
    ime varchar(50) not null,
    lozinka_hash text,
    aktivan boolean not null default false,
    reset_kod text null,
    auth_key text,
    vreme_registracije timestamptz
);

-- Imutable
-- filtrirati neprimerene reci?
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


create table kategorija(
    id serial primary key,
    naziv varchar(50) not null,
    roditelj_id int, -- koristi se prilikom rekonstrukcije stabla (vrednosti levo i desno)
    levo int, -- struktura stabla je definisana preko ugnjezdenih skupova (nested set)
    desno int,
    constraint fk_roditelj_kategorija
        foreign key (roditelj_id)
        references kategorija(id) 
        on delete cascade
);
create index idx_roditelj_kategorija on kategorija(roditelj_id);

-- igra sadrzi niz asocijacija
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
