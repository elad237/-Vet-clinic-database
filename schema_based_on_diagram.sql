CREATE TABLE patients(
   id serial PRIMARY KEY,
   name VARCHAR(255) NOT NULL,
   date_of_birth DATE
);

CREATE TABLE treatments(
   id serial PRIMARY KEY,
   type VARCHAR(100),
   name VARCHAR(250)
);

CREATE TABLE medical_histories(
   id serial PRIMARY KEY,
   patient_id INT,
   admitted_at TIMESTAMP,
   status VARCHAR(100),
   CONSTRAINT fk_patient
      FOREIGN KEY(patient_id) 
	  REFERENCES patients(id)
	  ON DELETE CASCADE
);

CREATE TABLE invoices(
   id serial PRIMARY KEY,
   medical_history_id INT,
   total_amount REAL,
   generated_at TIMESTAMP,
   payed_at TIMESTAMP,
   CONSTRAINT fk_medical_history
      FOREIGN KEY(medical_history_id) 
	  REFERENCES medical_histories(id)
	  ON DELETE CASCADE
);

CREATE TABLE invoice_items(
   id serial PRIMARY KEY,
   invoice_id INT,
   treatment_id INT,
   unit_price REAL,
   quantity INT,
   total_price REAL,
   CONSTRAINT fk_invoice_item
      FOREIGN KEY(invoice_id) 
	  REFERENCES invoices(id)
	  ON DELETE CASCADE,
    CONSTRAINT fk_treatment
      FOREIGN KEY(treatment_id) 
	  REFERENCES treatments(id)
	  ON DELETE CASCADE
);

CREATE TABLE medical_histories_has_treatments (
    medical_history_id INT REFERENCES medical_histories(id),
    treatment_id INT REFERENCES treatments(id)
);

CREATE INDEX ON medical_histories (patient_id);
CREATE INDEX ON invoices (medical_history_id);
CREATE INDEX ON invoice_items (invoice_id);
CREATE INDEX ON invoice_items (treatment_id);
CREATE INDEX ON medical_histories_has_treatments (medical_history_id);
CREATE INDEX ON medical_histories_has_treatments (treatment_id);
