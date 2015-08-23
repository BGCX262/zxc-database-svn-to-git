create table album (
	id number(10) primary key,
	name varchar2(128) not null
);

create table artist (
	id number(10) primary key,
	name varchar2(128) not null
);

create table song (
	id number(10) primary key,
	name varchar2(128) not null,
	data blob not null,
	albumid number(10),
	artistid number(10),
	foreign key (albumid) references album(id),
	foreign key (artistid) references artist(id)
);

create index album_name_index on album(name);
create index artist_name_index on artist(name);
create index song_name_index on song(name);

create sequence album_sequence
	increment by 1
	start with 1
	nomaxvalue
	nocycle
	nocache;

create sequence artist_sequence
	increment by 1
	start with 1
	nomaxvalue
	nocycle
	nocache;

create sequence song_sequence
	increment by 1
	start with 1
	nomaxvalue
	nocycle
	nocache;

create or replace trigger album_seq_trigger
	before insert on album for each row when (new.id is null)
	begin
		select album_sequence.nextval into :new.id from dual;
	end;
/

create or replace trigger artist_seq_trigger
	before insert on artist for each row when (new.id is null)
	begin
		select artist_sequence.nextval into :new.id from dual;
	end;
/

create or replace trigger song_seq_trigger
	before insert on song for each row when (new.id is null)
	begin
		select song_sequence.nextval into :new.id from dual;
	end;
/

create or replace package refcursor_pkg as
	type ref_cursor is ref cursor;
end refcursor_pkg;
/

create or replace procedure select_by_artist(
	curs in out refcursor_pkg.ref_cursor,
	artist in varchar) as
	begin
		open curs for
			select song.id, song.name, album.name
			from artist, song, album
			where upper(artist.name) = upper(select_by_artist.artist)
			and artist.id = song.artistid
			and song.albumid = album.id;
	end;
/

create or replace procedure select_by_album(
	curs in out refcursor_pkg.ref_cursor,
	album in varchar) as
	begin
		open curs for
			select song.id, song.name, artist.name
			from album, song, artist
			where upper(album.name) = upper(select_by_album.album)
			and album.id = song.albumid
			and song.artistid = artist.id;
	end;
/

create or replace procedure select_by_title(
	curs in out refcursor_pkg.ref_cursor,
	title in varchar) as
	begin
		open curs for
			select song.id, song.name, artist.name, album.name
			from song, artist, album
			where upper(song.name) like '%' || upper(select_by_title.title) || '%'
			and song.artistid = artist.id
			and song.albumid = album.id;
	end;
/

create or replace procedure select_by_songid(
	songid in number,
	title out varchar,
	artist out varchar,
	data out blob) as
	begin
		select song.name, artist.name, song.data
		into select_by_songid.title, select_by_songid.artist, select_by_songid.data
		from song, artist
		where song.id = select_by_songid.songid
		and song.artistid = artist.id;
	end;
/
