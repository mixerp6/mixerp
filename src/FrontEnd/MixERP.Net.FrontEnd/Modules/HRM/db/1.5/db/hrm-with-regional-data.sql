﻿-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/01.types-domains-tables-and-constraints/tables-and-constraints.sql --<--<--
 /********************************************************************************
Copyright (C) MixERP Inc. (http://mixof.org).
This file is part of MixERP.
MixERP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 2 of the License.
MixERP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with MixERP.  If not, see <http://www.gnu.org/licenses/>.
***********************************************************************************/

DROP SCHEMA IF EXISTS hrm CASCADE;
CREATE SCHEMA hrm;

CREATE TABLE hrm.education_levels
(
    education_level_id                      SERIAL NOT NULL PRIMARY KEY,
    education_level_name                    national character varying(50) NOT NULL UNIQUE,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);


CREATE TABLE hrm.employment_status_codes
(
    employment_status_code_id               integer NOT NULL PRIMARY KEY,
    status_code                             national character varying(12) NOT NULL UNIQUE,
    status_code_name                        national character varying(100) NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.employment_statuses
(
    employment_status_id                    SERIAL NOT NULL PRIMARY KEY,
    employment_status_code                  national character varying(12) NOT NULL UNIQUE,
    employment_status_name                  national character varying(100) NOT NULL,
    is_contract                             boolean NOT NULL DEFAULT(false),
    default_employment_status_code_id       integer NOT NULL REFERENCES hrm.employment_status_codes,
    description                             text DEFAULT(''),    
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.job_titles
(
    job_title_id                            SERIAL NOT NULL PRIMARY KEY,
    job_title_code                          national character varying(12) NOT NULL UNIQUE,
    job_title_name                          national character varying(100) NOT NULL,
    description                             text DEFAULT(''),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.pay_grades
(
    pay_grade_id                            SERIAL NOT NULL PRIMARY KEY,
    pay_grade_code                          national character varying(12) NOT NULL UNIQUE,
    pay_grade_name                          national character varying(100) NOT NULL,
    minimum_salary                          decimal(24, 4) NOT NULL,
    maximum_salary                          decimal(24, 5) NOT NULL
                                            CHECK(maximum_salary >= minimum_salary),
    description                             text DEFAULT(''),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.shifts
(
    shift_id                            SERIAL NOT NULL PRIMARY KEY,
    shift_code                          national character varying(12) NOT NULL UNIQUE,
    shift_name                          national character varying(100) NOT NULL,
    begins_from                         time NOT NULL,
    ends_on                             time NOT NULL,
    description                         text DEFAULT(''),
    audit_user_id                       integer NULL REFERENCES office.users(user_id),
    audit_ts                            TIMESTAMP WITH TIME ZONE NULL 
                                        DEFAULT(NOW())    
);

CREATE TABLE hrm.leave_types
(
    leave_type_id                           SERIAL NOT NULL PRIMARY KEY,
    leave_type_code                         national character varying(12) NOT NULL UNIQUE,
    leave_type_name                         national character varying(100) NOT NULL,
    description                             text DEFAULT(''),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.office_hours
(
    office_hour_id                          SERIAL NOT NULL PRIMARY KEY,
    office_id                               integer NOT NULL REFERENCES office.offices(office_id),
    shift_id                                integer NOT NULL REFERENCES hrm.shifts,
    week_day_id                             integer NOT NULL REFERENCES core.week_days(week_day_id),
    begins_from                             time NOT NULL,
    ends_on                                 time NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL    
);

CREATE TABLE hrm.leave_benefits
(
    leave_benefit_id                       SERIAL NOT NULL PRIMARY KEY,
    leave_benefit_code                     national character varying(12) NOT NULL UNIQUE,
    leave_benefit_name                     national character varying(128) NOT NULL,
    total_days                              public.integer_strict NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.employee_types
(
    employee_type_id                        SERIAL NOT NULL PRIMARY KEY,
    employee_type_code                      national character varying(12) NOT NULL UNIQUE,
    employee_type_name                      national character varying(128) NOT NULL,
    account_id                              bigint NOT NULL REFERENCES core.accounts(account_id),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.employees
(
    employee_id                             SERIAL NOT NULL PRIMARY KEY,
    employee_code                           national character varying(12) NOT NULL,
    first_name                              national character varying(50) NOT NULL,
    middle_name                             national character varying(50) DEFAULT(''),
    last_name                               national character varying(50) DEFAULT(''),
    employee_name                           national character varying(160) NOT NULL,
    gender_code                             national character varying(4) NOT NULL 
                                            REFERENCES core.genders(gender_code),
    marital_status_id                       integer NOT NULL REFERENCES core.marital_statuses(marital_status_id),
    joined_on                               date NULL,
    office_id                               integer NOT NULL REFERENCES office.offices(office_id),
    user_id                                 integer REFERENCES office.users(user_id),
    employee_type_id                        integer NOT NULL REFERENCES hrm.employee_types(employee_type_id),
    current_department_id                   integer NOT NULL REFERENCES office.departments(department_id),
    current_role_id                         integer REFERENCES office.roles(role_id),
    current_employment_status_id            integer NOT NULL REFERENCES hrm.employment_statuses(employment_status_id),
    current_job_title_id                    integer NOT NULL REFERENCES hrm.job_titles(job_title_id),
    current_pay_grade_id                    integer NOT NULL REFERENCES hrm.pay_grades(pay_grade_id),
    current_shift_id                        integer NOT NULL REFERENCES hrm.shifts(shift_id),
    nationality_code                        national character varying(12) REFERENCES core.nationalities(nationality_code),
    date_of_birth                           date,
    photo                                   public.image,
    zip_code                                national character varying(128) DEFAULT(''),
    address_line_1                          national character varying(128) DEFAULT(''),
    address_line_2                          national character varying(128) DEFAULT(''),
    street                                  national character varying(128) DEFAULT(''),
    city                                    national character varying(128) DEFAULT(''),
    state                                   national character varying(128) DEFAULT(''),    
    country_id                              integer REFERENCES core.countries(country_id),
    phone_home                              national character varying(128) DEFAULT(''),
    phone_cell                              national character varying(128) DEFAULT(''),
    phone_office_extension                  national character varying(128) DEFAULT(''),
    phone_emergency                         national character varying(128) DEFAULT(''),
    phone_emergency2                        national character varying(128) DEFAULT(''),
    email_address                           national character varying(128) DEFAULT(''),
    website                                 national character varying(128) DEFAULT(''),
    blog                                    national character varying(128) DEFAULT(''),
    is_smoker                               boolean,
    is_alcoholic                            boolean,
    with_disabilities                       boolean,
    low_vision                              boolean,
    uses_wheelchair                         boolean,
    hard_of_hearing                         boolean,
    is_aphonic                              boolean,
    is_cognitively_disabled                 boolean,
    is_autistic                             boolean,
    service_ended_on                        date NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.employee_identification_details
(
    employee_identification_detail_id       BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    identification_type_code                national character varying(12) NOT NULL 
                                            REFERENCES core.identification_types(identification_type_code),
    identification_number                   national character varying(128) NOT NULL,
    expires_on                              date,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())                                          
);

CREATE UNIQUE INDEX employee_identification_details_employee_id_itc_uix
ON hrm.employee_identification_details(employee_id, UPPER(identification_type_code));



CREATE TABLE hrm.employee_social_network_details
(
    employee_social_network_detail_id       BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    social_network_name                     national character varying(128) NOT NULL
                                            REFERENCES core.social_networks(social_network_name),
    social_network_id                       national character varying(128) NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.contracts
(
    contract_id                             BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    office_id                               integer NOT NULL REFERENCES office.offices(office_id),
    department_id                           integer NOT NULL REFERENCES office.departments(department_id),
    role_id                                 integer REFERENCES office.roles(role_id),
    leave_benefit_id                        integer REFERENCES hrm.leave_benefits(leave_benefit_id),
    began_on                                date,
    ended_on                                date,
    employment_status_code_id               integer NOT NULL REFERENCES hrm.employment_status_codes(employment_status_code_id),
    verification_status_id                  integer NOT NULL REFERENCES core.verification_statuses(verification_status_id),
    verified_by_user_id                     integer REFERENCES office.users(user_id),
    verified_on                             date,
    verification_reason                     national character varying(128) NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.salary_frequencies
(
    salary_frequency_id                     integer NOT NULL PRIMARY KEY,
    salary_frequency_name                   national character varying(128) NOT NULL UNIQUE,
    frequency_id                            integer REFERENCES core.frequencies(frequency_id)
);

CREATE TABLE hrm.salary_types
(
    salary_type_id                          SERIAL NOT NULL PRIMARY KEY,
    salary_type_code                        national character varying(12) NOT NULL UNIQUE,
    salary_type_name                        national character varying(128) NOT NULL,
    account_id                              bigint NOT NULL REFERENCES core.accounts(account_id),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.wages_setup
(
    wages_setup_id                          SERIAL NOT NULL PRIMARY KEY,
    wages_setup_code                        national character varying(12) NOT NULL UNIQUE,
    wages_setup_name                        national character varying(128) NOT NULL,
    currency_code                           national character varying(12) NOT NULL REFERENCES core.currencies(currency_code),
    max_week_hours                          integer NOT NULL DEFAULT(0),
    hourly_rate                             public.money_strict NOT NULL,
    overtime_applicable                     boolean NOT NULL DEFAULT(true),
    overtime_hourly_rate                    public.money_strict2 NOT NULL,
    expense_account_id                      bigint NOT NULL REFERENCES core.accounts(account_id),
    description                             text,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);


CREATE TABLE hrm.employee_wages
(
    employee_wage_id                        BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    wages_setup_id                          integer NOT NULL REFERENCES hrm.wages_setup(wages_setup_id),
    currency_code                           national character varying(12) NOT NULL REFERENCES core.currencies(currency_code),
    max_week_hours                          integer NOT NULL,
    hourly_rate                             public.money_strict NOT NULL,
    overtime_applicable                     boolean NOT NULL,
    overtime_hourly_rate                    public.money_strict2 DEFAULT(0),
    posting_account_id                      bigint NOT NULL REFERENCES core.accounts(account_id),
    valid_till                              date NOT NULL,
    is_active                               boolean,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.provident_funds
(
    provident_fund_id                       SERIAL NOT NULL PRIMARY KEY,
    provident_fund_code                     national character varying(12) NOT NULL UNIQUE,
    provident_fund_name                     national character varying(128) NOT NULL,
    employee_contribution_rate              public.decimal_strict NOT NULL,
    employer_contribution_rate              public.decimal_strict NOT NULL,
    fund_holding_account_id                 bigint NOT NULL REFERENCES core.accounts(account_id),
    provident_fund_expense_account_id       bigint NOT NULL REFERENCES core.accounts(account_id),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.salary_taxes
(
    salary_tax_id                           SERIAL NOT NULL PRIMARY KEY,
    salary_tax_code                         national character varying(12) NOT NULL UNIQUE,
    salary_tax_name                         national character varying(128) NOT NULL,
    tax_authority_id                        integer NOT NULL REFERENCES core.tax_authorities(tax_authority_id),
    standard_deduction                      public.money_strict2 NOT NULL DEFAULT(0),
    personal_exemption                      public.money_strict2 NOT NULL DEFAULT(0),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.salary_tax_income_brackets
(
    salary_tax_income_bracket_id            SERIAL NOT NULL PRIMARY KEY,
    salary_tax_id                           integer NOT NULL REFERENCES hrm.salary_taxes(salary_tax_id),
    salary_from                             public.money_strict NOT NULL,
    salary_to                               public.money_strict NULL
                                            CHECK (salary_to > salary_from),
    income_tax_rate                         public.decimal_strict NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.employment_taxes
(
    employment_tax_id                       SERIAL NOT NULL PRIMARY KEY,
    employment_tax_code                     national character varying(12) NOT NULL UNIQUE,
    employment_tax_name                     national character varying(128) NOT NULL,
    tax_authority_id                        integer NOT NULL REFERENCES core.tax_authorities(tax_authority_id),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);


CREATE TABLE hrm.employment_tax_details
(
    employment_tax_detail_id                SERIAL NOT NULL PRIMARY KEY,
    employment_tax_id                       integer NOT NULL REFERENCES hrm.employment_taxes(employment_tax_id),
    employment_tax_detail_code              national character varying(12) NOT NULL UNIQUE,
    employment_tax_detail_name              national character varying(128) NOT NULL,
    employee_tax_rate                       public.decimal_strict NOT NULL,
    employer_tax_rate                       public.decimal_strict NOT NULL,    
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL    
);



CREATE TABLE hrm.salaries
(
    salary_id                               BIGSERIAL NOT NULL PRIMARY KEY,    
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    salary_type_id                          integer NOT NULL REFERENCES hrm.salary_types(salary_type_id),
    pay_grade_id                            integer NOT NULL REFERENCES hrm.pay_grades(pay_grade_id),
    salary_frequency_id                     integer NOT NULL REFERENCES hrm.salary_frequencies(salary_frequency_id),
    currency_code                           national character varying(12) NOT NULL REFERENCES core.currencies(currency_code),
    amount                                  public.money_strict NOT NULL,
    deduction_applicable                    boolean NOT NULL DEFAULT(false),
    auto_deduction_based_on_attendance      boolean NOT NULL DEFAULT(false),
    provident_fund_id                       integer NULL REFERENCES hrm.provident_funds(provident_fund_id),
    employment_tax_id                       integer NULL REFERENCES hrm.employment_taxes(employment_tax_id),
    salary_tax_id                           integer NULL REFERENCES hrm.salary_taxes(salary_tax_id),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);


CREATE TABLE hrm.employee_experiences
(
    employee_experience_id                  BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    organization_name                       national character varying(128) NOT NULL,
    title                                   national character varying(128) NOT NULL,
    started_on                              date,
    ended_on                                date,
    details                                 text,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.employee_qualifications
(
    employee_qualification_id               BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    education_level_id                      integer NOT NULL REFERENCES hrm.education_levels(education_level_id),
    institution                             national character varying(128) NOT NULL,
    majors                                  national character varying(128) NOT NULL,
    total_years                             integer,
    score                                   numeric,
    started_on                              date,
    completed_on                            date,
    details                                 text,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.holidays
(
    holiday_id                              BIGSERIAL NOT NULL PRIMARY KEY,
    office_id                               integer NOT NULL REFERENCES office.offices(office_id),
    holiday_name                            national character varying(128) NOT NULL,
    occurs_on                               date,
    ends_on                                 date,
    comment                                 text,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.leave_applications
(
    leave_application_id                    BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    leave_type_id                           integer NOT NULL REFERENCES hrm.leave_types(leave_type_id),
    entered_by                              integer NOT NULL REFERENCES office.users(user_id),
    applied_on                              date DEFAULT(NOW()),
    reason                                  text,
    start_date                              date,
    end_date                                date,
    verification_status_id                  integer NOT NULL REFERENCES core.verification_statuses(verification_status_id),
    verified_by_user_id                     integer REFERENCES office.users(user_id),
    verified_on                             date,
    verification_reason                     national character varying(128) NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.resignations
(
    resignation_id                          SERIAL NOT NULL PRIMARY KEY,
    entered_by                              integer NOT NULL REFERENCES office.users(user_id),
    notice_date                             date NOT NULL,
    desired_resign_date                     date NOT NULL,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    forward_to                              integer REFERENCES hrm.employees(employee_id),
    reason                                  national character varying(128) NOT NULL,
    details                                 text,
    verification_status_id                  integer NOT NULL REFERENCES core.verification_statuses(verification_status_id),
    verified_by_user_id                     integer REFERENCES office.users(user_id),
    verified_on                             date,
    verification_reason                     national character varying(128) NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.terminations
(
    termination_id                          SERIAL NOT NULL PRIMARY KEY,
    notice_date                             date NOT NULL,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id) UNIQUE,
    forward_to                              integer REFERENCES hrm.employees(employee_id),
    change_status_to                        integer NOT NULL REFERENCES hrm.employment_statuses(employment_status_id),
    reason                                  national character varying(128) NOT NULL,
    details                                 text,
    service_end_date                        date NOT NULL,
    verification_status_id                  integer NOT NULL REFERENCES core.verification_statuses(verification_status_id),
    verified_by_user_id                     integer REFERENCES office.users(user_id),
    verified_on                             date,
    verification_reason                     national character varying(128) NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
    
);

CREATE TABLE hrm.exit_types
(
    exit_type_id                            SERIAL NOT NULL PRIMARY KEY,
    exit_type_code                          national character varying(12) NOT NULL UNIQUE,
    exit_type_name                          national character varying(128) NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.exits
(
    exit_id                                 BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    forward_to                              integer REFERENCES hrm.employees(employee_id),
    change_status_to                        integer NOT NULL REFERENCES hrm.employment_statuses(employment_status_id),
    exit_type_id                            integer NOT NULL REFERENCES hrm.exit_types(exit_type_id),
    exit_interview_details                  text,
    reason                                  national character varying(128) NOT NULL,
    details                                 text,
    verification_status_id                  integer NOT NULL REFERENCES core.verification_statuses(verification_status_id),
    verified_by_user_id                     integer REFERENCES office.users(user_id),
    verified_on                             date,
    verification_reason                     national character varying(128) NULL,
    service_end_date                        date NOT NULL,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),    
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);


CREATE TABLE hrm.attendances
(
    attendance_id                           BIGSERIAL NOT NULL PRIMARY KEY,
    office_id                               integer NOT NULL REFERENCES office.offices(office_id),
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    attendance_date                         date NOT NULL,
    was_present                             boolean NOT NULL,
    check_in_time                           time NULL,
    check_out_time                          time NULL,
    overtime_hours                          numeric NOT NULL,
    was_absent                              boolean NOT NULL CHECK(was_absent != was_present),
    reason_for_absentism                    text,
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE UNIQUE INDEX attendance_date_employee_id_uix
ON hrm.attendances(attendance_date, employee_id);

CREATE TABLE hrm.deduction_setups
(
    deduction_setup_id                      SERIAL NOT NULL PRIMARY KEY,
    deduction_setup_code                    national character varying(12) NOT NULL UNIQUE,
    deduction_setup_name                    national character varying(128) NOT NULL,
    account_id                              integer NOT NULL REFERENCES core.accounts(account_id),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

CREATE TABLE hrm.salary_deductions
(
    salary_deduction_id                     BIGSERIAL NOT NULL PRIMARY KEY,
    employee_id                             integer NOT NULL REFERENCES hrm.employees(employee_id),
    deduction_setup_id                      integer NOT NULL REFERENCES hrm.deduction_setups(deduction_setup_id),
    currency_code                           national character varying(12) NOT NULL REFERENCES core.currencies(currency_code),
    amount                                  public.money_strict,
    begins_from                             date,
    ends_on                                 date CHECK(ends_on > begins_from),
    audit_user_id                           integer NULL REFERENCES office.users(user_id),
    audit_ts                                TIMESTAMP WITH TIME ZONE NULL 
                                            DEFAULT(NOW())    
);

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/02.functions-and-logic/functions/hrm.get_salary_tax_id_by_salary_tax_code.sql --<--<--
DROP FUNCTION IF EXISTS hrm.get_salary_tax_id_by_salary_tax_code(_salary_tax_code national character varying(12));
CREATE FUNCTION hrm.get_salary_tax_id_by_salary_tax_code(_salary_tax_code national character varying(12))
RETURNS integer
AS
$$
BEGIN
    RETURN salary_tax_id
    FROM hrm.salary_taxes
    WHERE salary_tax_code = $1;
END
$$
LANGUAGE plpgsql;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/02.functions-and-logic/logic/hrm.get_wage_attendance.sql --<--<--
DROP FUNCTION IF EXISTS hrm.get_wage_attendance
(
    _employee_id            integer,
    _as_of                  date
);

CREATE FUNCTION hrm.get_wage_attendance
(
    _employee_id            integer,
    _as_of                  date
)
RETURNS TABLE
(
    employee_id             integer,
    employee                text,
    photo                   text,
    attendance_date         date,
    hours_worked            numeric
)
AS
$$
BEGIN
    RETURN QUERY
    SELECT
        hrm.employees.employee_id,
        hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
        hrm.employees.photo::text,
        hrm.attendances.attendance_date,
        ROUND((EXTRACT(EPOCH FROM hrm.attendances.check_out_time - check_in_time)/3600)::numeric, 2) AS hours_worked
    FROM hrm.attendances
    INNER JOIN hrm.employees
    ON hrm.employees.employee_id = hrm.attendances.employee_id
    WHERE hrm.attendances.attendance_date <= _as_of
    AND was_present
    AND hrm.employees.employee_id = _employee_id;
END
$$
LANGUAGE plpgsql;

--SELECT * FROM hrm.get_wage_attendance(1, (NOW() + INTERVAL '10 days')::date);

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/02.functions-and-logic/triggers/employee_dismissal.sql --<--<--
DROP FUNCTION IF EXISTS hrm.dismiss_employee() CASCADE;

CREATE FUNCTION hrm.dismiss_employee()
RETURNS trigger
AS
$$
    DECLARE _service_end        date;
    DECLARE _new_status_id      integer;
BEGIN
    IF(hstore(NEW) ? 'change_status_to') THEN
        _new_status_id := NEW.change_status_to;
    END IF;

    IF(hstore(NEW) ? 'service_end_date') THEN
        _service_end := NEW.service_end_date;
    END IF;

    IF(_service_end = NULL) THEN
        IF(hstore(NEW) ? 'desired_resign_date') THEN
            _service_end := NEW.desired_resign_date;
        END IF;
    END IF;
    
    IF(NEW.verification_status_id > 0) THEN        
        UPDATE hrm.employees
        SET
            service_ended_on = NEW.service_end_date
        WHERE employee_id = NEW.employee_id;

        IF(_new_status_id IS NOT NULL) THEN
            UPDATE hrm.employees
            SET
                current_employment_status_id = _new_status_id
            WHERE employee_id = NEW.employee_id;
        END IF;        
    END IF;

    RETURN NEW;
END
$$
LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS hrm.undismiss_employee() CASCADE;

CREATE FUNCTION hrm.undismiss_employee()
RETURNS trigger
AS
$$
BEGIN
    UPDATE hrm.employees
    SET
        service_ended_on = NULL
    WHERE employee_id = OLD.employee_id;

    RETURN OLD;    
END
$$
LANGUAGE plpgsql;

CREATE TRIGGER dismiss_employee_trigger BEFORE INSERT OR UPDATE ON hrm.resignations FOR EACH ROW EXECUTE PROCEDURE hrm.dismiss_employee();
CREATE TRIGGER dismiss_employee_trigger BEFORE INSERT OR UPDATE ON hrm.terminations FOR EACH ROW EXECUTE PROCEDURE hrm.dismiss_employee();
CREATE TRIGGER dismiss_employee_trigger BEFORE INSERT OR UPDATE ON hrm.exits FOR EACH ROW EXECUTE PROCEDURE hrm.dismiss_employee();

CREATE TRIGGER undismiss_employee_trigger BEFORE DELETE ON hrm.resignations FOR EACH ROW EXECUTE PROCEDURE hrm.undismiss_employee();
CREATE TRIGGER undismiss_employee_trigger BEFORE DELETE ON hrm.terminations FOR EACH ROW EXECUTE PROCEDURE hrm.undismiss_employee();
CREATE TRIGGER undismiss_employee_trigger BEFORE DELETE ON hrm.exits FOR EACH ROW EXECUTE PROCEDURE hrm.undismiss_employee();

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/03.menus/0.menus.sql --<--<--
--This table should not be localized.
SELECT * FROM core.recreate_menu('HRM', '~/Modules/HRM/Index.mix', 'HRM', 0, NULL);

SELECT * FROM core.recreate_menu('Tasks', NULL, 'HRMTA', 1, core.get_menu_id('HRM'));
SELECT * FROM core.recreate_menu('Attendance', '~/Modules/HRM/Tasks/Attendance.mix', 'ATTNDCE', 2, core.get_menu_id('HRMTA'));
SELECT * FROM core.recreate_menu('Employees', '~/Modules/HRM/Tasks/Employees.mix', 'EMPL', 2, core.get_menu_id('HRMTA'));
SELECT * FROM core.recreate_menu('Contracts', '~/Modules/HRM/Tasks/Contracts.mix', 'CTRCT', 2, core.get_menu_id('HRMTA'));
SELECT * FROM core.recreate_menu('Leave Application', '~/Modules/HRM/Tasks/LeaveApplications.mix', 'LEVAPP', 2, core.get_menu_id('HRMTA'));
SELECT * FROM core.recreate_menu('Resignations', '~/Modules/HRM/Tasks/Resignations.mix', 'RESIGN', 2, core.get_menu_id('HRMTA'));
SELECT * FROM core.recreate_menu('Terminations', '~/Modules/HRM/Tasks/Terminations.mix', 'TERMIN', 2, core.get_menu_id('HRMTA'));
SELECT * FROM core.recreate_menu('Exits', '~/Modules/HRM/Tasks/Exits.mix', 'EXIT', 2, core.get_menu_id('HRMTA'));

SELECT * FROM core.recreate_menu('Verification', NULL, 'HRMVER', 1, core.get_menu_id('HRM'));
SELECT * FROM core.recreate_menu('Verify Contracts', '~/Modules/HRM/Verification/Contracts.mix', 'VERCTRCT', 2, core.get_menu_id('HRMVER'));
SELECT * FROM core.recreate_menu('Verify Leave Applications', '~/Modules/HRM/Verification/LeaveApplications.mix', 'VERLEVAPP', 2, core.get_menu_id('HRMVER'));
SELECT * FROM core.recreate_menu('Verify Resignations', '~/Modules/HRM/Verification/Resignations.mix', 'VERRESIGN', 2, core.get_menu_id('HRMVER'));
SELECT * FROM core.recreate_menu('Verify Terminations', '~/Modules/HRM/Verification/Terminations.mix', 'VERTERMIN', 2, core.get_menu_id('HRMVER'));
SELECT * FROM core.recreate_menu('Verify Exits', '~/Modules/HRM/Verification/Exits.mix', 'VEREXIT', 2, core.get_menu_id('HRMVER'));


SELECT * FROM core.recreate_menu('Payroll', NULL, 'PAYRL', 1, core.get_menu_id('HRM'));
SELECT * FROM core.recreate_menu('Wages', '~/Modules/HRM/Payroll/Wages.mix', 'WAGES', 2, core.get_menu_id('PAYRL'));
SELECT * FROM core.recreate_menu('Deduction', '~/Modules/HRM/Payroll/Deduction.mix', 'DEDUC', 2, core.get_menu_id('PAYRL'));
SELECT * FROM core.recreate_menu('Salary', '~/Modules/HRM/Payroll/Salary.mix', 'SALRY', 2, core.get_menu_id('PAYRL'));

SELECT * FROM core.recreate_menu('Setup & Maintenance', NULL, 'HRMSSM', 1, core.get_menu_id('HRM'));
SELECT * FROM core.recreate_menu('Salary Taxes', '~/Modules/HRM/Setup/SalaryTaxes.mix', 'SALTAX', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Salary Tax Income Brackets', '~/Modules/HRM/Setup/SalaryTaxIncomeBrackets.mix', 'STIBTAX', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Employment Taxes', '~/Modules/HRM/Setup/EmploymentTaxes.mix', 'EMPTAX', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Employment Tax Details', '~/Modules/HRM/Setup/EmploymentTaxDetails.mix', 'EMPTAXD', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Provident Funds', '~/Modules/HRM/Setup/ProvidentFunds.mix', 'PROFUN', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Holiday Setup', '~/Modules/HRM/Setup/HolidaySetup.mix', 'HOLDAY', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Salaries', '~/Modules/HRM/Setup/Salaries.mix', 'SETSAL', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Wages', '~/Modules/HRM/Setup/Wages.mix', 'SETWAGES', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Deductions', '~/Modules/HRM/Setup/Deductions.mix', 'SETDED', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Employment Statuses', '~/Modules/HRM/Setup/EmploymentStatuses.mix', 'EMPSTA', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Employee Types', '~/Modules/HRM/Setup/EmployeeTypes.mix', 'EMPTYP', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Education Levels', '~/Modules/HRM/Setup/EducationLevels.mix', 'EDULVL', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Job Titles', '~/Modules/HRM/Setup/JobTitles.mix', 'JOBTA', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Pay Grades', '~/Modules/HRM/Setup/PayGrades.mix', 'PATGR', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Salary Types', '~/Modules/HRM/Setup/SalaryTypes.mix', 'SALTYP', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Shifts', '~/Modules/HRM/Setup/Shifts.mix', 'SHIFT', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Office Hours', '~/Modules/HRM/Setup/OfficeHours.mix', 'OFFHRS', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Leave Types', '~/Modules/HRM/Setup/LeaveTypes.mix', 'LEVTYP', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Leave Benefits', '~/Modules/HRM/Setup/LeaveBenefits.mix', 'LEVBEN', 2, core.get_menu_id('HRMSSM'));
SELECT * FROM core.recreate_menu('Exit Types', '~/Modules/HRM/Setup/ExitTypes.mix', 'EXITTYP', 2, core.get_menu_id('HRMSSM'));

SELECT * FROM core.recreate_menu('HRM Reports', NULL, 'HRMRPT', 1, core.get_menu_id('HRM'));
SELECT * FROM core.recreate_menu('Attendances', '~/Modules/HRM/Reports/Attendances.mix', 'HRMRPTAT', 2, core.get_menu_id('HRMRPT'));


DELETE FROM policy.menu_access;
INSERT INTO policy.menu_access(office_id, menu_id, user_id)
SELECT office_id, menu_id, 2
FROM office.offices, core.menus;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/04.default-values/01.default-values.sql --<--<--
DO
$$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM core.attachment_lookup WHERE book = 'employee') THEN
        INSERT INTO core.attachment_lookup(book, resource, resource_key)
        SELECT 'employee',           'core.employees',  'employee_id';
    END IF;
END
$$
LANGUAGE plpgsql;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.contract_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.contract_scrud_view;

CREATE VIEW hrm.contract_scrud_view
AS
SELECT
    hrm.contracts.contract_id,
    hrm.employees.employee_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    office.offices.office_code || ' (' || office.offices.office_name || ')' AS office,
    office.departments.department_code || ' (' || office.departments.department_name || ')' AS department,
    office.roles.role_code || ' (' || office.roles.role_name || ')' AS role,
    hrm.leave_benefits.leave_benefit_code || ' (' || hrm.leave_benefits.leave_benefit_name || ')' AS leave_benefit,
    hrm.employment_status_codes.status_code || ' (' || hrm.employment_status_codes.status_code_name || ')' AS employment_status_code,
    hrm.contracts.began_on,
    hrm.contracts.ended_on
FROM hrm.contracts
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.contracts.employee_id
INNER JOIN office.offices
ON office.offices.office_id = hrm.contracts.office_id
INNER JOIN office.departments
ON office.departments.department_id = hrm.contracts.department_id
INNER JOIN office.roles
ON office.roles.role_id = hrm.contracts.role_id
INNER JOIN hrm.employment_status_codes
ON hrm.employment_status_codes.employment_status_code_id = hrm.contracts.employment_status_code_id
LEFT JOIN hrm.leave_benefits
ON hrm.leave_benefits.leave_benefit_id = hrm.contracts.leave_benefit_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.contract_verification_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.contract_verification_scrud_view;

CREATE VIEW hrm.contract_verification_scrud_view
AS
SELECT
    hrm.contracts.contract_id,
    hrm.employees.employee_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    office.offices.office_code || ' (' || office.offices.office_name || ')' AS office,
    office.departments.department_code || ' (' || office.departments.department_name || ')' AS department,
    office.roles.role_code || ' (' || office.roles.role_name || ')' AS role,
    hrm.leave_benefits.leave_benefit_code || ' (' || hrm.leave_benefits.leave_benefit_name || ')' AS leave_benefit,
    hrm.employment_status_codes.status_code || ' (' || hrm.employment_status_codes.status_code_name || ')' AS employment_status_code,
    hrm.contracts.began_on,
    hrm.contracts.ended_on
FROM hrm.contracts
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.contracts.employee_id
INNER JOIN office.offices
ON office.offices.office_id = hrm.contracts.office_id
INNER JOIN office.departments
ON office.departments.department_id = hrm.contracts.department_id
INNER JOIN office.roles
ON office.roles.role_id = hrm.contracts.role_id
INNER JOIN hrm.employment_status_codes
ON hrm.employment_status_codes.employment_status_code_id = hrm.contracts.employment_status_code_id
LEFT JOIN hrm.leave_benefits
ON hrm.leave_benefits.leave_benefit_id = hrm.contracts.leave_benefit_id
WHERE verification_status_id = 0;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.deduction_setup_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.deduction_setup_scrud_view;

CREATE VIEW hrm.deduction_setup_scrud_view
AS
SELECT
    hrm.deduction_setups.deduction_setup_id,
    hrm.deduction_setups.deduction_setup_code,
    hrm.deduction_setups.deduction_setup_name,
    core.accounts.account_number || ' (' || core.accounts.account_name || ')' AS account    
FROM hrm.deduction_setups
INNER JOIN core.accounts
ON core.accounts.account_id = hrm.deduction_setups.account_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employee_experience_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_experience_scrud_view;

CREATE VIEW hrm.employee_experience_scrud_view
AS
SELECT
    hrm.employee_experiences.employee_experience_id,
    hrm.employee_experiences.employee_id,
    hrm.employees.employee_name,
    hrm.employee_experiences.organization_name,
    hrm.employee_experiences.title,
    hrm.employee_experiences.started_on,
    hrm.employee_experiences.ended_on
FROM hrm.employee_experiences
INNER JOIN hrm.employees
ON hrm.employee_experiences.employee_id = hrm.employees.employee_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employee_identification_detail_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_identification_detail_scrud_view;

CREATE VIEW hrm.employee_identification_detail_scrud_view
AS
SELECT
    hrm.employee_identification_details.employee_identification_detail_id,
    hrm.employee_identification_details.employee_id,
    hrm.employees.employee_name,
    hrm.employee_identification_details.identification_type_code,
    core.identification_types.identification_type_name,
    hrm.employee_identification_details.identification_number,
    hrm.employee_identification_details.expires_on
FROM hrm.employee_identification_details
INNER JOIN hrm.employees
ON hrm.employee_identification_details.employee_id = hrm.employees.employee_id
INNER JOIN core.identification_types
ON hrm.employee_identification_details.identification_type_code = core.identification_types.identification_type_code;




-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employee_qualification_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_qualification_scrud_view;

CREATE VIEW hrm.employee_qualification_scrud_view
AS
SELECT
    hrm.employee_qualifications.employee_qualification_id,
    hrm.employee_qualifications.employee_id,
    hrm.employees.employee_name,
    hrm.education_levels.education_level_name,
    hrm.employee_qualifications.institution,
    hrm.employee_qualifications.majors,
    hrm.employee_qualifications.total_years,
    hrm.employee_qualifications.score,
    hrm.employee_qualifications.started_on,
    hrm.employee_qualifications.completed_on
FROM hrm.employee_qualifications
INNER JOIN hrm.employees
ON hrm.employee_qualifications.employee_id = hrm.employees.employee_id
INNER JOIN hrm.education_levels
ON hrm.employee_qualifications.education_level_id = hrm.education_levels.education_level_id;



-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employee_social_network_detail_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_social_network_detail_scrud_view;

CREATE VIEW hrm.employee_social_network_detail_scrud_view
AS
SELECT
    hrm.employee_social_network_details.employee_social_network_detail_id,
    hrm.employee_social_network_details.employee_id,
    hrm.employees.employee_name,
    hrm.employee_social_network_details.social_network_name,
    hrm.employee_social_network_details.social_network_id,
    core.social_networks.semantic_css_class,
    core.social_networks.base_url,
    core.social_networks.profile_url
FROM hrm.employee_social_network_details
INNER JOIN hrm.employees
ON hrm.employee_social_network_details.employee_id = hrm.employees.employee_id
INNER JOIN core.social_networks
ON core.social_networks.social_network_name = hrm.employee_social_network_details.social_network_name;



-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employee_type_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_type_scrud_view;

CREATE VIEW hrm.employee_type_scrud_view
AS
SELECT
    employee_type_id,
    employee_type_code,
    employee_type_name
FROM hrm.employee_types;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employee_wage_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_wage_scrud_view;

CREATE VIEW hrm.employee_wage_scrud_view
AS
SELECT
    hrm.employee_wages.employee_wage_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.wages_setup.wages_setup_code || ' (' || hrm.wages_setup.wages_setup_name || ')' AS wages_setup,
    hrm.employee_wages.currency_code,
    hrm.employee_wages.max_week_hours,
    hrm.employee_wages.hourly_rate,
    hrm.employee_wages.overtime_applicable,
    hrm.employee_wages.overtime_hourly_rate,
    hrm.employee_wages.valid_till,
    hrm.employee_wages.is_active
FROM hrm.employee_wages
INNER JOIN hrm.employees
ON hrm.employee_wages.employee_id = hrm.employees.employee_id
INNER JOIN hrm.wages_setup
ON hrm.wages_setup.wages_setup_id = hrm.employee_wages.wages_setup_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employment_tax_detail_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employment_tax_detail_scrud_view;

CREATE VIEW hrm.employment_tax_detail_scrud_view
AS
SELECT
    hrm.employment_tax_details.employment_tax_detail_id,
    hrm.employment_taxes.employment_tax_code || ' (' || hrm.employment_taxes.employment_tax_name || ')' AS employment_tax,
    hrm.employment_tax_details.employment_tax_detail_code,
    hrm.employment_tax_details.employment_tax_detail_name,
    hrm.employment_tax_details.employee_tax_rate,
    hrm.employment_tax_details.employer_tax_rate
FROM hrm.employment_tax_details
INNER JOIN hrm.employment_taxes
ON hrm.employment_taxes.employment_tax_id = hrm.employment_tax_details.employment_tax_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.employment_tax_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employment_tax_scrud_view;

CREATE VIEW hrm.employment_tax_scrud_view
AS
SELECT
    hrm.employment_taxes.employment_tax_id,
    hrm.employment_taxes.employment_tax_code,
    hrm.employment_taxes.employment_tax_name,
    core.tax_authorities.tax_authority_code || ' (' || core.tax_authorities.tax_authority_name || ')' AS tax_authority
FROM hrm.employment_taxes
INNER JOIN core.tax_authorities
ON hrm.employment_taxes.tax_authority_id = core.tax_authorities.tax_authority_id;



-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.exit_verification_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.exit_scrud_view;

CREATE VIEW hrm.exit_scrud_view
AS
SELECT
    hrm.exits.exit_id,
    hrm.exits.employee_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.exits.reason,
    forwarded_to.employee_code || ' (' || forwarded_to.employee_name || ' )' AS forward_to,
    hrm.employment_statuses.employment_status_code || ' (' || hrm.employment_statuses.employment_status_name || ')' AS employment_status,
    hrm.exit_types.exit_type_code || ' (' || hrm.exit_types.exit_type_name || ')' AS exit_type,
    hrm.exits.details,
    hrm.exits.exit_interview_details
FROM hrm.exits
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.exits.employee_id
INNER JOIN hrm.employment_statuses
ON hrm.employment_statuses.employment_status_id = hrm.exits.change_status_to
INNER JOIN hrm.exit_types
ON hrm.exit_types.exit_type_id = hrm.exits.exit_type_id
INNER JOIN hrm.employees AS forwarded_to
ON forwarded_to.employee_id = hrm.exits.forward_to
WHERE verification_status_id = 0;


-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.leave_application_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.leave_application_scrud_view;

CREATE VIEW hrm.leave_application_scrud_view
AS
SELECT
    hrm.leave_applications.leave_application_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.leave_types.leave_type_code || ' (' || hrm.leave_types.leave_type_name || ')' AS leave_type,
    office.users.user_name AS entered_by,
    hrm.leave_applications.applied_on,
    hrm.leave_applications.reason,
    hrm.leave_applications.start_date,
    hrm.leave_applications.end_date
FROM hrm.leave_applications
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.leave_applications.employee_id
INNER JOIN hrm.leave_types
ON hrm.leave_types.leave_type_id = hrm.leave_applications.leave_type_id
INNER JOIN office.users
ON office.users.user_id = hrm.leave_applications.entered_by;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.leave_application_verification_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.leave_application_verification_scrud_view;

CREATE VIEW hrm.leave_application_verification_scrud_view
AS
SELECT
    hrm.leave_applications.leave_application_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.leave_types.leave_type_code || ' (' || hrm.leave_types.leave_type_name || ')' AS leave_type,
    office.users.user_name AS entered_by,
    hrm.leave_applications.applied_on,
    hrm.leave_applications.reason,
    hrm.leave_applications.start_date,
    hrm.leave_applications.end_date
FROM hrm.leave_applications
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.leave_applications.employee_id
INNER JOIN hrm.leave_types
ON hrm.leave_types.leave_type_id = hrm.leave_applications.leave_type_id
INNER JOIN office.users
ON office.users.user_id = hrm.leave_applications.entered_by
WHERE verification_status_id = 0;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.office_hour_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.office_hour_scrud_view;

CREATE VIEW hrm.office_hour_scrud_view
AS
SELECT
    hrm.office_hours.office_hour_id,
    office.offices.office_code || ' (' || office.offices.office_name || ')' AS office,
    office.offices.logo_file as photo,
    hrm.shifts.shift_code || ' (' || hrm.shifts.shift_name || ')' AS shift,
    core.week_days.week_day_code || ' (' || core.week_days.week_day_name || ')' AS week_day,
    hrm.office_hours.begins_from,
    hrm.office_hours.ends_on
FROM hrm.office_hours
INNER JOIN office.offices
ON office.offices.office_id = hrm.office_hours.office_id
INNER JOIN hrm.shifts
ON hrm.shifts.shift_id = hrm.office_hours.shift_id
INNER JOIN core.week_days
ON core.week_days.week_day_id = hrm.office_hours.week_day_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.provident_fund_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.provident_fund_scrud_view;

CREATE VIEW hrm.provident_fund_scrud_view
AS
SELECT
    hrm.provident_funds.provident_fund_id,
    hrm.provident_funds.provident_fund_code,
    hrm.provident_funds.provident_fund_name,
    hrm.provident_funds.employee_contribution_rate::text || '%' AS employee_contribution_rate,
    hrm.provident_funds.employer_contribution_rate::text || '%' AS employer_contribution_rate,
    holding_account.account_number || ' (' || holding_account.account_name || ')' AS holiding_account,
    expense_account.account_number || ' (' || expense_account.account_name || ')' AS expense_account    
FROM hrm.provident_funds
INNER JOIN core.accounts AS holding_account
ON hrm.provident_funds.fund_holding_account_id = holding_account.account_id
INNER JOIN core.accounts AS expense_account
ON hrm.provident_funds.provident_fund_expense_account_id = expense_account.account_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.resignation_verification_view.sql --<--<--
DROP VIEW IF EXISTS hrm.resignation_verification_scrud_view;

CREATE VIEW hrm.resignation_verification_scrud_view
AS
SELECT
    hrm.resignations.resignation_id,
    office.users.user_name AS entered_by,
    hrm.resignations.notice_date,
    hrm.resignations.desired_resign_date,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    forward_to.employee_code || ' (' || forward_to.employee_name || ')' AS forward_to,
    hrm.resignations.reason
FROM hrm.resignations
INNER JOIN office.users
ON office.users.user_id = hrm.resignations.entered_by
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.resignations.employee_id
INNER JOIN hrm.employees AS forward_to
ON forward_to.employee_id = hrm.resignations.forward_to
WHERE verification_status_id = 0;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.resignation_view.sql --<--<--
DROP VIEW IF EXISTS hrm.resignation_scrud_view;

CREATE VIEW hrm.resignation_scrud_view
AS
SELECT
    hrm.resignations.resignation_id,
    office.users.user_name AS entered_by,
    hrm.resignations.notice_date,
    hrm.resignations.desired_resign_date,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    forward_to.employee_code || ' (' || forward_to.employee_name || ')' AS forward_to,
    hrm.resignations.reason
FROM hrm.resignations
INNER JOIN office.users
ON office.users.user_id = hrm.resignations.entered_by
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.resignations.employee_id
INNER JOIN hrm.employees AS forward_to
ON forward_to.employee_id = hrm.resignations.forward_to;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.salary_deduction_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.salary_deduction_scrud_view;

CREATE VIEW hrm.salary_deduction_scrud_view
AS
SELECT
    hrm.salary_deductions.salary_deduction_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.deduction_setups.deduction_setup_code || ' (' || hrm.deduction_setups.deduction_setup_name || ')' AS deduction_setup,
    hrm.salary_deductions.currency_code,
    hrm.salary_deductions.amount,
    hrm.salary_deductions.begins_from,
    hrm.salary_deductions.ends_on
FROM hrm.salary_deductions
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.salary_deductions.employee_id
INNER JOIN hrm.deduction_setups
ON hrm.deduction_setups.deduction_setup_id = hrm.salary_deductions.deduction_setup_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.salary_tax_income_bracket_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.salary_tax_income_bracket_scrud_view;

CREATE VIEW hrm.salary_tax_income_bracket_scrud_view
AS
SELECT
    hrm.salary_tax_income_brackets.salary_tax_income_bracket_id,
    hrm.salary_taxes.salary_tax_code || ' (' || hrm.salary_taxes.salary_tax_name || ')' AS salary_tax,
    hrm.salary_tax_income_brackets.salary_from,
    hrm.salary_tax_income_brackets.salary_to,
    hrm.salary_tax_income_brackets.income_tax_rate::text || '%' AS income_tax_rate
FROM hrm.salary_tax_income_brackets
INNER JOIN hrm.salary_taxes
ON hrm.salary_tax_income_brackets.salary_tax_id = hrm.salary_taxes.salary_tax_id;


-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.salary_tax_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.salary_tax_scrud_view;

CREATE VIEW hrm.salary_tax_scrud_view
AS
SELECT
    hrm.salary_taxes.salary_tax_id,
    hrm.salary_taxes.salary_tax_code,
    hrm.salary_taxes.salary_tax_name,
    core.tax_authorities.tax_authority_code || ' (' || core.tax_authorities.tax_authority_name || ')' AS tax_authority,
    hrm.salary_taxes.standard_deduction,
    hrm.salary_taxes.personal_exemption
FROM hrm.salary_taxes
INNER JOIN core.tax_authorities
ON hrm.salary_taxes.tax_authority_id = core.tax_authorities.tax_authority_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.salary_tax_scurd_view.sql --<--<--
DROP VIEW IF EXISTS hrm.salary_tax_scurd_view;

CREATE VIEW hrm.salary_tax_scurd_view
AS
SELECT
    hrm.salary_taxes.salary_tax_id,
    hrm.salary_taxes.salary_tax_code,
    hrm.salary_taxes.salary_tax_name,
    core.tax_authorities.tax_authority_code || ' (' || core.tax_authorities.tax_authority_name || ')' AS tax_authority,
    hrm.salary_taxes.standard_deduction,
    hrm.salary_taxes.personal_exemption
FROM hrm.salary_taxes
INNER JOIN core.tax_authorities
ON hrm.salary_taxes.tax_authority_id = core.tax_authorities.tax_authority_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.termination_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.termination_scrud_view;

CREATE VIEW hrm.termination_scrud_view
AS
SELECT
    hrm.terminations.termination_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.terminations.notice_date,
    hrm.terminations.service_end_date,
    forwarded_to.employee_code || ' (' || forwarded_to.employee_name || ' )' AS forward_to,
    hrm.employment_statuses.employment_status_code || ' (' || hrm.employment_statuses.employment_status_name || ')' AS employment_status,
    hrm.terminations.reason,
    hrm.terminations.details
FROM hrm.terminations
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.terminations.employee_id
INNER JOIN hrm.employment_statuses
ON hrm.employment_statuses.employment_status_id = hrm.terminations.change_status_to
INNER JOIN hrm.employees AS forwarded_to
ON forwarded_to.employee_id = hrm.terminations.forward_to;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.scrud-views/hrm.termination_verification_scrud_view.sql --<--<--
DROP VIEW IF EXISTS hrm.termination_verification_scrud_view;

CREATE VIEW hrm.termination_verification_scrud_view
AS
SELECT
    hrm.terminations.termination_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.terminations.notice_date,
    hrm.terminations.service_end_date,
    forwarded_to.employee_code || ' (' || forwarded_to.employee_name || ' )' AS forward_to,
    hrm.employment_statuses.employment_status_code || ' (' || hrm.employment_statuses.employment_status_name || ')' AS employment_status,
    hrm.terminations.reason,
    hrm.terminations.details
FROM hrm.terminations
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.terminations.employee_id
INNER JOIN hrm.employment_statuses
ON hrm.employment_statuses.employment_status_id = hrm.terminations.change_status_to
INNER JOIN hrm.employees AS forwarded_to
ON forwarded_to.employee_id = hrm.terminations.forward_to
WHERE verification_status_id = 0;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.selector-views/hrm.deduction_account_selector_view.sql --<--<--
DROP VIEW IF EXISTS hrm.deduction_account_selector_view;

CREATE VIEW hrm.deduction_account_selector_view
AS
SELECT * FROM core.account_scrud_view
--Accounts Receivable, Accounts Payable
WHERE account_master_id = ANY(ARRAY[10110, 15010])
ORDER BY account_id;


-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.selector-views/hrm.provident_fund_expense_account_selector_view.sql --<--<--
DROP VIEW IF EXISTS hrm.provident_fund_expense_account_selector_view;

CREATE VIEW hrm.provident_fund_expense_account_selector_view
AS
SELECT * FROM core.account_scrud_view
WHERE account_master_id >= 20400
ORDER BY account_id; --Expenses


-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.selector-views/hrm.provident_fund_holding_account_selector_view.sql --<--<--
DROP VIEW IF EXISTS hrm.provident_fund_holding_account_selector_view;

CREATE VIEW hrm.provident_fund_holding_account_selector_view
AS
SELECT * FROM core.account_scrud_view
--Accounts Receivable, Accounts Payable
WHERE account_master_id = ANY(ARRAY[10110, 15010])
ORDER BY account_id;


-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.selector-views/hrm.wage_posting_account_selector_view.sql --<--<--
DROP VIEW IF EXISTS hrm.wage_posting_account_selector_view;

CREATE VIEW hrm.wage_posting_account_selector_view
AS
SELECT * FROM core.account_scrud_view
--Accounts Receivable, Accounts Payable
WHERE account_master_id = ANY(ARRAY[10110, 15010])
ORDER BY account_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.selector-views/hrm.wages_account_selector_view.sql --<--<--
DROP VIEW IF EXISTS hrm.wages_account_selector_view;

CREATE VIEW hrm.wages_account_selector_view
AS
SELECT * FROM core.account_scrud_view
WHERE account_master_id >= 20400
ORDER BY account_id; --Expenses


-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.views/hrm.attendance_view.sql --<--<--
DROP VIEW IF EXISTS hrm.attendance_view;

CREATE VIEW hrm.attendance_view
AS
SELECT
    hrm.attendances.attendance_id,
    hrm.attendances.office_id,
    office.offices.office_code || ' (' || office.offices.office_name || ')' AS office,
    hrm.attendances.employee_id,
    hrm.employees.employee_code || ' (' || hrm.employees.employee_name || ')' AS employee,
    hrm.employees.photo,
    hrm.attendances.attendance_date,
    hrm.attendances.was_present,
    hrm.attendances.check_in_time,
    hrm.attendances.check_out_time,
    hrm.attendances.overtime_hours,
    hrm.attendances.was_absent,
    hrm.attendances.reason_for_absentism
FROM hrm.attendances
INNER JOIN office.offices
ON office.offices.office_id = hrm.attendances.office_id
INNER JOIN hrm.employees
ON hrm.employees.employee_id = hrm.attendances.employee_id;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/05.views/hrm.employee_view.sql --<--<--
DROP VIEW IF EXISTS hrm.employee_view;

CREATE VIEW hrm.employee_view
AS
SELECT
    hrm.employees.employee_id,
    hrm.employees.first_name,
    hrm.employees.middle_name,
    hrm.employees.last_name,
    hrm.employees.employee_code,
    hrm.employees.employee_name,
    hrm.employees.gender_code,
    core.genders.gender_name,
    core.marital_statuses.marital_status_code || ' (' || core.marital_statuses.marital_status_name || ')' AS marital_status,
    hrm.employees.joined_on,
    hrm.employees.office_id,
    office.offices.office_code || ' (' || office.offices.office_name || ')' AS office,
    hrm.employees.user_id,
    office.users.user_name,
    hrm.employees.employee_type_id,
    hrm.employee_types.employee_type_code || ' (' || hrm.employee_types.employee_type_name || ')' AS employee_type,
    hrm.employees.current_department_id,
    office.departments.department_code || ' (' || office.departments.department_name || ')' AS current_department,    
    hrm.employees.current_role_id,
    office.roles.role_code || ' (' || office.roles.role_name || ')' AS role,
    hrm.employees.current_employment_status_id,
    hrm.employment_statuses.employment_status_code || ' (' || employment_status_name || ')' AS employment_status,
    hrm.employees.current_job_title_id,
    hrm.job_titles.job_title_code || ' (' || hrm.job_titles.job_title_name || ')' AS job_title,
    hrm.employees.current_pay_grade_id,
    hrm.pay_grades.pay_grade_code || ' (' || hrm.pay_grades.pay_grade_name || ')' AS pay_grade,
    hrm.employees.current_shift_id,
    hrm.shifts.shift_code || ' (' || hrm.shifts.shift_name || ')' AS shift,
    hrm.employees.nationality_code,
    core.nationalities.nationality_code || ' (' || core.nationalities.nationality_name || ')' AS nationality,
    hrm.employees.date_of_birth,
    hrm.employees.photo,
    hrm.employees.zip_code,
    hrm.employees.address_line_1,
    hrm.employees.address_line_2,
    hrm.employees.street,
    hrm.employees.city,
    hrm.employees.state,
    hrm.employees.country_id,
    core.countries.country_name AS country,
    hrm.employees.phone_home,
    hrm.employees.phone_cell,
    hrm.employees.phone_office_extension,
    hrm.employees.phone_emergency,
    hrm.employees.phone_emergency2,
    hrm.employees.email_address,
    hrm.employees.website,
    hrm.employees.blog,
    hrm.employees.is_smoker,
    hrm.employees.is_alcoholic,
    hrm.employees.with_disabilities,
    hrm.employees.low_vision,
    hrm.employees.uses_wheelchair,
    hrm.employees.hard_of_hearing,
    hrm.employees.is_aphonic,
    hrm.employees.is_cognitively_disabled,
    hrm.employees.is_autistic
FROM hrm.employees
INNER JOIN core.genders
ON hrm.employees.gender_code = core.genders.gender_code
INNER JOIN core.marital_statuses
ON hrm.employees.marital_status_id = core.marital_statuses.marital_status_id
INNER JOIN office.offices
ON hrm.employees.office_id = office.offices.office_id
INNER JOIN office.departments
ON hrm.employees.current_department_id = office.departments.department_id
INNER JOIN hrm.employee_types
ON hrm.employee_types.employee_type_id = hrm.employees.employee_type_id
INNER JOIN hrm.employment_statuses
ON hrm.employees.current_employment_status_id = hrm.employment_statuses.employment_status_id
INNER JOIN hrm.job_titles
ON hrm.employees.current_job_title_id = hrm.job_titles.job_title_id
INNER JOIN hrm.pay_grades
ON hrm.employees.current_pay_grade_id = hrm.pay_grades.pay_grade_id
INNER JOIN hrm.shifts
ON hrm.employees.current_shift_id = hrm.shifts.shift_id
LEFT JOIN office.users
ON hrm.employees.user_id = office.users.user_id
LEFT JOIN office.roles
ON hrm.employees.current_role_id = office.roles.role_id
LEFT JOIN core.nationalities
ON hrm.employees.nationality_code = core.nationalities.nationality_code
LEFT JOIN core.countries
ON hrm.employees.country_id = core.countries.country_id
WHERE COALESCE(service_ended_on, 'infinity') >= NOW();

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/99.ownership.sql --<--<--
DO
$$
    DECLARE this record;
BEGIN
    IF(CURRENT_USER = 'mix_erp') THEN
        RETURN;
    END IF;

    FOR this IN 
    SELECT * FROM pg_tables 
    WHERE NOT schemaname = ANY(ARRAY['pg_catalog', 'information_schema'])
    AND tableowner <> 'mix_erp'
    LOOP
        EXECUTE 'ALTER TABLE '|| this.schemaname || '.' || this.tablename ||' OWNER TO mix_erp;';
    END LOOP;
END
$$
LANGUAGE plpgsql;

DO
$$
    DECLARE this record;
BEGIN
    IF(CURRENT_USER = 'mix_erp') THEN
        RETURN;
    END IF;

    FOR this IN 
    SELECT 'ALTER '
        || CASE WHEN p.proisagg THEN 'AGGREGATE ' ELSE 'FUNCTION ' END
        || quote_ident(n.nspname) || '.' || quote_ident(p.proname) || '(' 
        || pg_catalog.pg_get_function_identity_arguments(p.oid) || ') OWNER TO mix_erp;' AS sql
    FROM   pg_catalog.pg_proc p
    JOIN   pg_catalog.pg_namespace n ON n.oid = p.pronamespace
    WHERE  NOT n.nspname = ANY(ARRAY['pg_catalog', 'information_schema'])
    LOOP        
        EXECUTE this.sql;
    END LOOP;
END
$$
LANGUAGE plpgsql;


DO
$$
    DECLARE this record;
BEGIN
    IF(CURRENT_USER = 'mix_erp') THEN
        RETURN;
    END IF;

    FOR this IN 
    SELECT * FROM pg_views
    WHERE NOT schemaname = ANY(ARRAY['pg_catalog', 'information_schema'])
    AND viewowner <> 'mix_erp'
    LOOP
        EXECUTE 'ALTER VIEW '|| this.schemaname || '.' || this.viewname ||' OWNER TO mix_erp;';
    END LOOP;
END
$$
LANGUAGE plpgsql;


DO
$$
    DECLARE this record;
BEGIN
    IF(CURRENT_USER = 'mix_erp') THEN
        RETURN;
    END IF;

    FOR this IN 
    SELECT 'ALTER SCHEMA ' || nspname || ' OWNER TO mix_erp;' AS sql FROM pg_namespace
    WHERE nspname NOT LIKE 'pg_%'
    AND nspname <> 'information_schema'
    LOOP
        EXECUTE this.sql;
    END LOOP;
END
$$
LANGUAGE plpgsql;



DO
$$
    DECLARE this record;
BEGIN
    IF(CURRENT_USER = 'mix_erp') THEN
        RETURN;
    END IF;

    FOR this IN 
    SELECT      'ALTER TYPE ' || n.nspname || '.' || t.typname || ' OWNER TO mix_erp;' AS sql
    FROM        pg_type t 
    LEFT JOIN   pg_catalog.pg_namespace n ON n.oid = t.typnamespace 
    WHERE       (t.typrelid = 0 OR (SELECT c.relkind = 'c' FROM pg_catalog.pg_class c WHERE c.oid = t.typrelid)) 
    AND         NOT EXISTS(SELECT 1 FROM pg_catalog.pg_type el WHERE el.oid = t.typelem AND el.typarray = t.oid)
    AND         typtype NOT IN ('b')
    AND         n.nspname NOT IN ('pg_catalog', 'information_schema')
    LOOP
        EXECUTE this.sql;
    END LOOP;
END
$$
LANGUAGE plpgsql;

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/99.regional-data/Retail Industry.sample --<--<--
-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/Modules/HRM/db/1.5/db/src/01.types-domains-tables-and-constraints/tables-and-constraints.sql --<--<--
/********************************************************************************
Copyright (C) MixERP Inc. (http://mixof.org).
This file is part of MixERP.
MixERP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 2 of the License.
MixERP is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with MixERP.  If not, see <http://www.gnu.org/licenses/>.
***********************************************************************************/

--The meaning of the following should not change
INSERT INTO hrm.employment_status_codes
SELECT -7, 'DEC', 'Deceased'                UNION ALL
SELECT -6, 'DEF', 'Defaulter'               UNION ALL
SELECT -5, 'TER', 'Terminated'              UNION ALL
SELECT -4, 'RES', 'Resigned'                UNION ALL
SELECT -3, 'EAR', 'Early Retirement'        UNION ALL
SELECT -2, 'RET', 'Normal Retirement'       UNION ALL
SELECT -1, 'CPO', 'Contract Period Over'    UNION ALL
SELECT  0, 'NOR', 'Normal Employment'       UNION ALL
SELECT  1, 'OCT', 'On Contract'             UNION ALL
SELECT  2, 'PER', 'Permanent Job'           UNION ALL
SELECT  3, 'RTG', 'Retiring';

INSERT INTO hrm.employment_statuses(employment_status_code, employment_status_name, default_employment_status_code_id, is_contract)
SELECT 'EMP', 'Employee',       0, false UNION ALL
SELECT 'INT', 'Intern',         1, true UNION ALL
SELECT 'CON', 'Contract Basis', 1, true UNION ALL
SELECT 'PER', 'Permanent',      2, false;

INSERT INTO hrm.job_titles(job_title_code, job_title_name)
SELECT 'INT', 'Internship'                      UNION ALL
SELECT 'DEF', 'Default'                         UNION ALL
SELECT 'EXC', 'Executive'                       UNION ALL
SELECT 'MAN', 'Manager'                         UNION ALL
SELECT 'GEM', 'General Manager'                 UNION ALL
SELECT 'BME', 'Board Member'                    UNION ALL
SELECT 'CEO', 'Chief Executive Officer'         UNION ALL
SELECT 'CTO', 'Chief Technology Officer';

INSERT INTO hrm.pay_grades(pay_grade_code, pay_grade_name, minimum_salary, maximum_salary)
SELECT 'L-1', 'Level 1', 0, 0;

INSERT INTO hrm.shifts(shift_code, shift_name, begins_from, ends_on)
SELECT 'MOR', 'Morning Shift',  '6:00'::time,   '14:00'::time   UNION ALL
SELECT 'DAY', 'Day Shift',      '14:00',        '20:00'         UNION ALL
SELECT 'NIT', 'Night Shift',    '20:00',        '6:00';

INSERT INTO hrm.employee_types(employee_type_code, employee_type_name, account_id)
SELECT 'DEF', 'Default',            core.get_account_id_by_account_number('20100') UNION ALL
SELECT 'OUE', 'Outdoor Employees',  core.get_account_id_by_account_number('20100') UNION ALL
SELECT 'PRO', 'Project Employees',  core.get_account_id_by_account_number('20100') UNION ALL
SELECT 'SUP', 'Support Staffs',     core.get_account_id_by_account_number('20100') UNION ALL
SELECT 'ENG', 'Engineers',          core.get_account_id_by_account_number('20100');

INSERT INTO hrm.salary_types(salary_type_code, salary_type_name, account_id)
SELECT 'BAS', 'Basic Salary',       core.get_account_id_by_account_number('43700') UNION
SELECT 'OTS', 'Overtime Salary',    core.get_account_id_by_account_number('43700') UNION ALL
SELECT 'COM', 'Commision',          core.get_account_id_by_account_number('43700') UNION ALL
SELECT 'EBE', 'Employee Benefits',  core.get_account_id_by_account_number('43700');

INSERT INTO hrm.leave_types(leave_type_code, leave_type_name)
SELECT 'NOR', 'Normal' UNION ALL
SELECT 'EME', 'Emergency' UNION ALL
SELECT 'ILL', 'Illness';

INSERT INTO hrm.exit_types(exit_type_code, exit_type_name)
SELECT 'COE', 'Contract Period Over' UNION ALL
SELECT 'RET', 'Retirement' UNION ALL
SELECT 'RES', 'Resignation' UNION ALL
SELECT 'TER', 'Termination' UNION ALL
SELECT 'DEC', 'Deceased';

INSERT INTO hrm.salary_frequencies(salary_frequency_id, frequency_id, salary_frequency_name)
SELECT 0, NULL::integer,    'Weekly' UNION ALL
SELECT 1, NULL,             'Biweekly' UNION ALL
SELECT 2, 2,                'Monhtly' UNION ALL
SELECT 3, 3,                'Quarterly' UNION ALL
SELECT 4, 4,                'Semi Annually' UNION ALL
SELECT 5, 5,                'Anually';


DO
$$
    DECLARE _employment_tax_id      integer;
    DECLARE _tax_authority_id       integer;
BEGIN
    SELECT tax_authority_id INTO _tax_authority_id
    FROM core.tax_authorities
    WHERE tax_authority_code = 'IRS';

    INSERT INTO hrm.employment_taxes(tax_authority_id, employment_tax_code, employment_tax_name)
    SELECT _tax_authority_id, 'USET', 'United States Employment Tax';

    SELECT employment_tax_id INTO _employment_tax_id
    FROM hrm.employment_taxes
    WHERE employment_tax_code = 'USET';

    INSERT INTO hrm.employment_tax_details(employment_tax_id, employment_tax_detail_code, employment_tax_detail_name, employee_tax_rate, employer_tax_rate)
    SELECT _employment_tax_id, 'SS', 'Social Security', 6.2,    6.2 UNION ALL
    SELECT _employment_tax_id, 'MC', 'Medicare',        1.45,   1.45;
END
$$
LANGUAGE plpgsql;

INSERT INTO hrm.salary_taxes(salary_tax_code, salary_tax_name, tax_authority_id, standard_deduction, personal_exemption)
SELECT 'SIN', 'Single Individual', core.get_tax_authority_id_by_tax_authority_code('IRS'), 6200, 3900 UNION ALL
SELECT 'MSF', 'Married (Separately Filing)', core.get_tax_authority_id_by_tax_authority_code('IRS'), 6200, 3900 UNION ALL
SELECT 'WID', 'Qualified Widower', core.get_tax_authority_id_by_tax_authority_code('IRS'), 12400, 3900 UNION ALL
SELECT 'HOH', 'Head of Household', core.get_tax_authority_id_by_tax_authority_code('IRS'), 9100, 3900;

INSERT INTO hrm.salary_tax_income_brackets(salary_tax_id, salary_from, salary_to, income_tax_rate)
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 1,      9225,           10 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 9225,   37450,          15 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 37450,  90750,          25 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 90750,  189300,         28 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 189300, 411500,         33 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 411500, 413200,         35 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('SIN'), 413200, NULL,           39.6;

INSERT INTO hrm.salary_tax_income_brackets(salary_tax_id, salary_from, salary_to, income_tax_rate)
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 1,      9225,           10 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 9225,   37450,          15 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 37450,  75600,          25 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 75600,  115225,         28 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 115225, 205750,         33 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 205750, 232425,         35 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('MSF'), 232425, NULL,           39.6;

INSERT INTO hrm.salary_tax_income_brackets(salary_tax_id, salary_from, salary_to, income_tax_rate)
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 1,      18450,          10 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 18450,  74900,          15 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 74900,  151200,         25 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 151200, 230450,         28 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 230450, 411500,         33 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 411500, 464850,         35 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('WID'), 464850, NULL,           39.6;

INSERT INTO hrm.salary_tax_income_brackets(salary_tax_id, salary_from, salary_to, income_tax_rate)
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 1,      13150,          10 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 13150,  50200,          15 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 50200,  129600,         25 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 129600, 209850,         28 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 209850, 411500,         33 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 411500, 439000,         35 UNION ALL
SELECT hrm.get_salary_tax_id_by_salary_tax_code('HOH'), 439000, NULL,           39.6;

INSERT INTO hrm.deduction_setups(deduction_setup_code, deduction_setup_name, account_id)
SELECT 'REN', 'Rent', core.get_account_id_by_account_number('20100') UNION ALL
SELECT 'BOR', 'Borrowings Deduction', core.get_account_id_by_account_number('10400') UNION ALL
SELECT 'FIC', 'Fitness Club', core.get_account_id_by_account_number('20100');

INSERT INTO hrm.wages_setup(wages_setup_code, wages_setup_name, currency_code, max_week_hours, hourly_rate, overtime_applicable, overtime_hourly_rate, expense_account_id)
SELECT 'NY-LIW', 'New York Living Wage', 'USD', 40, 14.30, true, 28.60, core.get_account_id_by_account_number('43800');

-->-->-- C:/Users/nirvan/Desktop/mixerp/0. GitHub/src/FrontEnd/MixERP.Net.FrontEnd/Modules/HRM/db/1.5/db/src/99.sample/kanban.sql --<--<--
DO
$$
    DECLARE objects text[];
    DECLARE users int[];
    DECLARE _user_id int;
    DECLARE _obj text;
BEGIN
    SELECT array_agg(user_id)
        INTO users
    FROM office.users INNER JOIN office.roles ON office.users.role_id = office.roles.role_id AND NOT is_system;

    objects := array[
        'hrm.employees', 
        'hrm.employment_statuses',
        'hrm.salaries',
        'hrm.wages_setup',
        'hrm.employee_type_scrud_view',
        'hrm.employee_identification_detail_scrud_view',
        'hrm.employee_social_network_detail_scrud_view',
        'hrm.employee_experience_scrud_view',
        'hrm.employee_qualification_scrud_view',
        'hrm.employee_wage_scrud_view',
        'hrm.leave_application_scrud_view',
        'hrm.contract_scrud_view',
        'hrm.exit_scrud_view',
        'hrm.education_levels',
        'hrm.job_titles',
        'hrm.pay_grades',
        'hrm.salary_types',
        'hrm.shifts',
        'hrm.office_hour_scrud_view',
        'hrm.leave_types',
        'hrm.leave_benefits',
        'hrm.exit_types',
        ''
        
        
        ];

    FOREACH _user_id IN ARRAY users
    LOOP
        FOREACH _obj IN ARRAY objects
        LOOP
            PERFORM core.create_kanban(_obj, _user_id, 'Checklist');
            PERFORM core.create_kanban(_obj, _user_id, 'High Priority');
            PERFORM core.create_kanban(_obj, _user_id, 'Done');
        END LOOP;
    END LOOP;
END
$$
LANGUAGE plpgsql;
