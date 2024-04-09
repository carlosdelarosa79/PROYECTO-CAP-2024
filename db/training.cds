namespace com.training;

using {Country} from '@sap/cds/common';

entity Orders {
    key ClientEmail  : String(65);
        FirstName    : String(65);
        LastName     : String(65);
        CreatedOn    : Date;
        Reviewed     : Boolean;
        Approved     : Boolean;
        //Country_code : String(20);
        Status       : String(2);
        Country      : Country;
}
