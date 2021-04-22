DROP FUNCTION IF EXISTS insert_crowd_mapping_data(text,text,text,text,text,text,text,text,text,text,text,text);
--Assumes only one value being inserted

CREATE OR REPLACE FUNCTION insert_crowd_mapping_data (
    _geojson TEXT,
    _name TEXT,
    _supplies TEXT,
    _contact TEXT,
    _number TEXT,	
    _street_address TEXT,
    _barangay TEXT,
    _municipality_city TEXT,
    _province TEXT,	
    _region TEXT, 	
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
    EXECUTE ' INSERT INTO '||quote_ident(_the_table)||' (the_geom, name, supplies, contact, number, street_address, barangay, municipality_city, province, region, sched, more)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
            ' USING _the_geom, _name, _supplies, _contact, _number, _street_address, _barangay, _municipality_city, _province, _region, _sched, _more;
            
    RETURN 1;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER ;

--Grant access to the public user
GRANT EXECUTE ON FUNCTION insert_crowd_mapping_data(text, text, text, text, text, text, text, text, text, text, text, text) TO publicuser;
