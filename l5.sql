1)
CREATE OR REPLACE FUNCTION registration_create( registration_date DATE, client_id INT, tour_id INT, employee_id INT) RETURNS INTEGER
AS $$
	DECLARE
	f_client_id "Client"."Client_id"%TYPE;
	f_employee_id "Employee"."Employee_id"%TYPE;
	f_tour_id "Tour"."Tour_id"%TYPE;	
	BEGIN	
	
	SELECT "Client_id" INTO f_client_id FROM "Client" WHERE "Client_id"= client_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this client % is not exist', client_id;
	END IF;
	SELECT "Employee_id" INTO f_employee_id FROM "Employee" WHERE "Employee_id"= employee_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this employee % is not exist', employee_id;
	END IF;
	SELECT "Tour_id" INTO f_tour_id FROM "Tour" WHERE "Tour_id"= tour_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this tour % is not exist', tour_id;
	END IF;
	INSERT INTO "Registration" VALUES(registration_date, f_client_id, f_employee_id, f_tour_id);
	RAISE NOTICE 'Registration has been done';
	RETURN '1';
	END;
$$ LANGUAGE plpgSQL;



	SELECT registration_create('2018-12-13','4','5','8')
	SELECT * FROM "Registration"
2)
CREATE OR REPLACE FUNCTION delete_tour_to_country() RETURNS TRIGGER
AS $$	
	BEGIN	
		DELETE FROM "Tour" AS T1 
		WHERE "Tour_id"=(
				SELECT T."Tour_id"
				FROM "TCC" T 
				WHERE "Country_id" = OLD."Country_id"
				);
		RETURN NEW;
	END;
$$ LANGUAGE plpgSQL;
drop trigger if exists Delete_tours on "Country"
CREATE TRIGGER Delete_tours
BEFORE UPDATE OR DELETE ON "Country"
FOR EACH ROW 
EXECUTE PROCEDURE delete_tour_to_country()
DELETE FROM "Country" WHERE "Country_id" = 2
	SELECT * FROM "Tour"
INSERT INTO "TCC"("TCC_id","Tour_id", "Country_id", "City_id")
VALUES ('1', '1', '1', '1');
INSERT INTO "TCC"("TCC_id", "Tour_id", "Country_id", "City_id")
VALUES ('2', '2', '2', '2');
DELETE FROM "TCC" WHERE "TCC_id"=18
INSERT INTO "Country"("Country_id","Country_name")
VALUES ('1','Тайланд');
INSERT INTO "Country"("Country_id","Country_name")
VALUES ('2','Украина');

3)
CREATE OR REPLACE FUNCTION tour_information( Tour_id INT) RETURNS TABLE("Tour_id" INT, "City" VARCHAR, "Insuranse_agency" CHAR, "Payout_amount" INT, "Amount_of_tour_days" INT, "Price" INT, "Transport_type" CHAR)
AS $$	
	BEGIN	
	RETURN QUERY
		SELECT T."Tour_id", C."City_name", I."Name_of_insurance_agency", I."Payout_amount", T."Amount_of_tour_days", T."Price", Tr."Type_of_transport"
		FROM "Tour" AS T JOIN "TCC" USING("Tour_id")
			JOIN "City" AS C USING("City_id")
			JOIN "Insurance" USING("Tour_id")
			JOIN "Insurance_agency" AS I USING("Insurance_agency_id")
			JOIN "Passage" USING("TCC_id")
			JOIN "Transport" AS Tr USING("Transport_id")
			WHERE T."Tour_id" = Tour_id
			GROUP BY T."Tour_id", C."City_name", I."Name_of_insurance_agency", I."Payout_amount", T."Amount_of_tour_days", T."Price", Tr."Type_of_transport";
	END;
$$ LANGUAGE plpgSQL;

DROP FUNCTION tour_information(integer)

	SELECT tour_information(1)

4)
CREATE OR REPLACE FUNCTION tour_create( Termination_data DATE, Amount_of_tour_days INT, Description Text, Price INT)
AS $$	
	BEGIN	
	
	INSERT INTO "Tour" VALUES(Termination_data, Amount_of_tour_days, Description, Price);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION tour_delete( Tour_id INT) 
AS $$	
	BEGIN	
	
	DELETE FROM "Tour" WHERE "Tour_id" = Tour_id;
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION client_create( Passport_number_and_series VARCHAR(8), Phone_number VARCHAR(13), First_name varchar, Last_name varchar NOT NULL, Patronymic varchar NOT NULL) 
AS $$	
	BEGIN	
	
	INSERT INTO "Client" VALUES(Passport_number_and_series, Phone_number, First_name, Last_name, Patronymic);
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION client_delete( Client_id INT) 
AS $$	
	BEGIN	
	
	DELETE FROM "Client" WHERE "Client_id" = Client_id;
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION employee_create( Salary INT, Phone_number VARCHAR(13), First_name varchar, Last_name varchar, Patronymic varchar, Award INT)
AS $$	
	BEGIN	
	
	INSERT INTO "Employee" VALUES(Salary, Phone_number, First_name, Last_name, Patronymic, Award);
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION employee_delete( Employee_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Employee" WHERE "Employee_id" = Employee_id;
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION registration_create( registration_date DATE, client_id INT, tour_id INT, employee_id INT)
AS $$
	DECLARE
	f_client_id "Client"."Client_id"%TYPE;
	f_employee_id "Employee"."Employee_id"%TYPE;
	f_tour_id "Tour"."Tour_id"%TYPE;	
	BEGIN	
	
	SELECT "Client_id" INTO f_client_id FROM "Client" WHERE "Client_id"= client_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this client % is not exist', client_id;
	END IF;
	SELECT "Employee_id" INTO f_employee_id FROM "Employee" WHERE "Employee_id"= employee_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this employee % is not exist', employee_id;
	END IF;
	SELECT "Tour_id" INTO f_tour_id FROM "Tour" WHERE "Tour_id"= tour_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this tour % is not exist', tour_id;
	END IF;
	INSERT INTO "Registration" VALUES(registration_date, f_client_id, f_employee_id, f_tour_id);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION registration_delete( Registration_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Registration" WHERE "Registration_id" = Registration_id;

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION city_create( City_name varchar)
AS $$	
	BEGIN	
	
	INSERT INTO "City" VALUES(City_name);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION city_delete( City_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "City" WHERE "City_id" = City_id;

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION country_create( Country_name varchar)
AS $$	
	BEGIN	
	
	INSERT INTO "Country" VALUES(Country_name);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION country_delete( Country_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Country" WHERE "Country_id" = Country_id;
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION TCC_create( city_id INT, country_id INT, tour_id INT)
AS $$
	DECLARE
	f_city_id "City"."City_id"%TYPE;
	f_country_id "Country"."Country_id"%TYPE;
	f_tour_id "Tour"."Tour_id"%TYPE;	
	BEGIN	
	
	SELECT "City_id" INTO f_city_id FROM "City" WHERE "City_id"= city_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this city % is not exist', city_id;
	END IF;
	SELECT "Country_id" INTO f_country_id FROM "Country" WHERE "Country_id"= Country_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this country % is not exist', employee_id;
	END IF;
	SELECT "Tour_id" INTO f_tour_id FROM "Tour" WHERE "Tour_id"= tour_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this tour % is not exist', tour_id;
	END IF;
	INSERT INTO "TCC" VALUES(f_city_id, f_country_id, f_tour_id);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION TCC_delete( TCC_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "TCC" WHERE "TCC_id" = TCC_id;

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION place_of_residence_create( place_of_residence_name varchar, type_of_place_of_residence varchar, conditions varchar)
AS $$	
	BEGIN	
	
	INSERT INTO "Place_of_residence" VALUES(place_of_residence_name, type_of_place_of_residence, conditions);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION place_of_residence_delete( Place_of_residence_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Place_of_residence" WHERE "Place_of_residence_id" = Place_of_residence_id;

	END;
CREATE OR REPLACE FUNCTION transport_create( class_of_transport varchar, type_of_transport varchar)
AS $$	
	BEGIN	
	
	INSERT INTO "Transport" VALUES(class_of_transport, type_of_transport);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION transport_delete( Transport INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Transport" WHERE "Transport_id" = Transport_id;

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION insurance_agency_create( Name_of_insurance_agency varchar, Price_of_insurance INT, Payout_amount INT)
AS $$	
	BEGIN	
	
	INSERT INTO "Insurance_agency" VALUES(Name_of_insurance_agency, Price_of_insurance, Payout_amount);

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION insurance_agency_delete( Insurance_agency INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Insurance_agency" WHERE "Insurance_agency_id" = Insurance_agency_id;

	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION insurance_create( client_id INT, tour_id INT, insurance_agency_id INT)
AS $$
	DECLARE
	f_client_id "Client"."Client_id"%TYPE;
	f_insurance_agency_id "Insurance_agency"."Insurance_agency_id"%TYPE;
	f_tour_id "Tour"."Tour_id"%TYPE;	
	BEGIN	
	
	SELECT "Client_id" INTO f_client_id FROM "Client" WHERE "Client_id"= client_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this client % is not exist', city_id;
	END IF;
	SELECT "Insurance_agency_id" INTO f_insurance_agency_id FROM "Insurance_agency" WHERE "Insurance_agency_id"= insurance_agency_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this insurance agency % is not exist', employee_id;
	END IF;
	SELECT "Tour_id" INTO f_tour_id FROM "Tour" WHERE "Tour_id"= Tour_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this tour % is not exist', tour_id;
	END IF;
	INSERT INTO "Insurance" VALUES(f_client_id, f_tour_id, f_insurance_agency_id);
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION Insurance_delete( Insurance_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Insurance" WHERE "Insurance_id" = Insurance_id;
	
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION passage_create( client_id INT, TCC_id INT, transport_id INT)
AS $$
	DECLARE
	f_client_id "Client"."Client_id"%TYPE;
	f_transport_id "Transport"."Transport_id"%TYPE;
	f_TCC_id "TCC"."TCC_id"%TYPE;	
	BEGIN	
	
	SELECT "Client_id" INTO f_client_id FROM "Client" WHERE "Client_id"= client_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this client % is not exist', city_id;
	END IF;
	SELECT "Transport_id" INTO f_transport_id FROM "Transport" WHERE "Transport_id"= transport_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this transport % is not exist', employee_id;
	END IF;
	SELECT "TCC_id" INTO f_TCC_id FROM "TCC" WHERE "TCC_id"= TCC_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this TCC % is not exist', tour_id;
	END IF;
	INSERT INTO "Passage" VALUES(f_client_id, f_TCC_id, f_transport_id);
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION passage_delete( Passage_id INT)
AS $$	
	BEGIN	
	
	DELETE FROM "Passage" WHERE "Passage_id" = Passage_id;
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION residence_create(ariving_data Date, client_id INT, TCC_id INT, place_of_residence_id INT)
AS $$
	DECLARE
	f_client_id "Client"."Client_id"%TYPE;
	f_place_of_residence_id "Place_of_residence"."Place_of_residence_id"%TYPE;
	f_TCC_id "TCC"."TCC_id"%TYPE;	
	BEGIN	
	
	SELECT "Client_id" INTO f_client_id FROM "Client" WHERE "Client_id"= client_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this client % is not exist', city_id;
	END IF;
	SELECT "Place_of_residence_id" INTO f_place_of_residence_id FROM "Place_of_residence" WHERE "Place_of_residence_id"= place_of_residence_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this place_of_residence % is not exist', employee_id;
	END IF;
	SELECT "TCC_id" INTO f_TCC_id FROM "TCC" WHERE "TCC_id"= TCC_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'ERROR: this TCC % is not exist', tour_id;
	END IF;
	INSERT INTO "Residence" VALUES(ariving_data, f_client_id, f_place_of_residence_id, f_transport_id);
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION residence_delete( Residence_id INT) 
AS $$	
	BEGIN	
	
	DELETE FROM "Residence" WHERE "Residence_id" = Residence_id;
	END;
$$ LANGUAGE plpgSQL;
CREATE OR REPLACE FUNCTION search_tour( country varchar, city varchar, price_low INT, price_high INT, amount_of_days INT) RETURNS TABLE("Country" VARCHAR, "City" VARCHAR, "Insuranse_agency" CHAR, "Price_of_insurance" INT, "Amount_of_tour_days" INT, "Price" INT, "Transport_type" CHAR)
AS $$	
	BEGIN	
	RETURN QUERY
		SELECT Cou."Country_name", C."City_name", I."Name_of_insurance_agency", I."Price_of_insurance", T."Amount_of_tour_days", T."Price", Tr."Type_of_transport"
		FROM "Tour" AS T JOIN "TCC" USING("Tour_id")
			JOIN "City" AS C USING("City_id")
			JOIN "Country" AS Cou USING("Country_id")
			JOIN "Insurance" USING("Tour_id")
			JOIN "Insurance_agency" AS I USING("Insurance_agency_id")
			JOIN "Passage" USING("TCC_id")
			JOIN "Transport" AS Tr USING("Transport_id")
			WHERE Cou."Country_name"=country AND C."City_name"=city AND T."Price" BETWEEN price_low AND price_high AND T."Amount_of_days" = amount_of_days;
			GROUP BY Cou."Country_name", C."City_name", I."Name_of_insurance_agency", I."Price_of_insurance", T."Amount_of_tour_days", T."Price", Tr."Type_of_transport";
	END;
$$ LANGUAGE plpgSQL;