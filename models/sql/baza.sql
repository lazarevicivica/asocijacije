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

-- TODO obezbediti nepromenljivost podataka u okviru polja
-- filtrirati neprimerene reci?
create table polje(
    id serial primary key,
    kreator_id int not null,
    sadrzaj text not null unique,
    constraint fk_kreator_asocijacija
        foreign key (kreator_id)
        references korisnik(id) 
        on delete restrict
);

create table asocijacija(
    id serial primary key,
    resenje_id int not null,
    kreator_id int not null,
    constraint fk_kreator_asocijacija
        foreign key (kreator_id)
        references korisnik(id) 
        on delete restrict,        
    constraint fk_resenje_asocijacija
        foreign key (resenje_id)
        references polje(id) 
        on delete restrict
);

create table asocijacija_polje(
    asocijacija_id int not null,
    polje_id int not null,
    primary key (asocijacija_id, polje_id),
    constraint fk_resenje_asocijacija
        foreign key (resenje_id)
        references polje(id) 
        on delete restrict    
);

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
    meta json not null,
    constraint fk_kategorija_igra
        foreign key (kategorija_id)
        references kategorija(id) 
        on delete restrict,
    constraint fk_kreator_igra
        foreign key (korisnik_id)
        references korisnik(id) 
        on delete restrict
);
create index idx_kategorija_igra on igra(kategorija_id);

create table igra_asocijacija(
    igra_id int not null,
    asocijacija_id int not null,
    primary key(igra_id, asocijacija_id)
);
