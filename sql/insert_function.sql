DROP FUNCTION IF EXISTS insert_crowd_mapping_data(text,text,text,text,text,text,text,text);
--Assumes only one value being inserted

CREATE OR REPLACE FUNCTION insert_crowd_mapping_data (
    _geojson TEXT,
    _name TEXT,
    _product TEXT,
    _price TEXT,
    _contact TEXT,	
    _address TEXT, 
    _sched TEXT,
    _more TEXT)    
--Has to return something in order to be used in a "SELECT" statement
RETURNS integer
AS $$
DECLARE 
    _the_geom GEOMETRY;
	--The name of your table in cartoDB
	_the_table TEXT := 'saanmaynagdedeliver';
BEGIN
    --Convert the GeoJSON to a geometry type for insertion. 
    _the_geom := ST_SetSRID(ST_GeomFromGeoJSON(_geojson),4326); 
	

	--Executes the insert given the supplied geometry, description, and username, while protecting against SQL injection.
    EXECUTE ' INSERT INTO '||quote_ident(_the_table)||' (the_geom, name, product, price, contact, address, sched, more)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            ' USING _the_geom, _name, _product, _price, _contact, _address, _sched, _more;
            
    RETURN 1;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER ;

--Grant access to the public user
GRANT EXECUTE ON FUNCTION insert_crowd_mapping_data(text, text, text, text, text, text, text, text) TO publicuser;
