namespace proyecto.personal;

/**
 * estoy usando esa libreria "CUID" la cual me sirve para generar el "ID" A TODAS LAS ENTITY
 * se recomienda usar esto por buenas practicas.
 * "MANAGED" se utiliza para generar 4 tipos de control tipo auditoria,
 *  nos sirve para ver la fecha y usuario cuando crea o modifica un registro
 */
using {
    cuid,
    managed
} from '@sap/cds/common';


/**
 * aca se define todas las entidades necesarias
 */

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);
};

type Dec : Decimal(16, 2);

/**
 * con el "context" podemos agrupar las entidades que tiene relacion
 */
context materials {
    entity Products : cuid, managed {
        Name             : localized String;
        Description      : localized String;
        ImageUrl         : String;
        ReleaseDate      : DateTime default $now;
        DiscontinuedDate : DateTime;
        Price            : Dec;
        Height           : type of Price;
        Width            : Decimal(16, 2);
        Depth            : Decimal(16, 2);
        Quantity         : Decimal(16, 2);
        Supplier         : Association to one sales.Suppliers;
        UnitOfMeasure    : Association to UnitOfMeasures;
        Currency         : Association to Currencies;
        DimensionsUnit   : Association to DimensionsUnits;
        Category         : Association to Categories;
        SalesData        : Association to many sales.SalesData
                               on SalesData.Product = $self;
        Reviews          : Association to many ProductReview
                               on Reviews.Product = $self
    };

    entity Categories : cuid {
        Name : localized String;
    };

    entity StockAvailability : cuid {
        Description : localized String;
        Product     : Association to Products;
    };

    entity Currencies : cuid {
        Description : localized String;
    };

    entity UnitOfMeasures : cuid {
        Description : localized String;
    };

    entity DimensionsUnits : cuid {
        Description : localized String;
    };

    entity ProductReview : cuid, managed {
        createdAt  : DateTime;
        createdBy  : String;
        modifiedAt : String;
        modifiedBy : String;
        Name       : String;
        Rating     : Integer;
        Comment    : String;
        Product    : Association to Products;
    };

}

context sales {
    entity Orders : cuid {
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems
                       on Item.Order = $self;
    };

    entity OrderItems : cuid {
        Order    : Association to Orders;
        Product  : Association to materials.Products;
        Quantity : Integer;
    };

    entity Suppliers : cuid, managed {
        Name    : type of materials.Products : Name;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many materials.Products
                      on Product.Supplier = $self;
    };


    entity Months : cuid {
        Description      : localized String;
        ShortDescription : localized String;
    };

    entity SalesData : cuid, managed {
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        Product       : Association to materials.Products;
        Currency      : Association to materials.Currencies;
        DeliveryMonth : Association to sales.Months;

    };

}

context reports {
    entity AverageRating as
        select from personal.materials.ProductReview {
            Product.ID,
            avg(Rating) as AverageRating : Decimal(16, 2)
        }
        group by
            Product.ID;

    entity Products as
    select from personal.materials.Products 
    mixin {
        ToStockAvailability : Association to personal.materials.StockAvailability
                        on ToStockAvailability.ID = $projection.StockAvailability;
        ToAverageRating : Association to AverageRating
                        on  ToAverageRating.ID;              
    }

    into {
        *,
        ToAverageRating.AverageRating as Rating,
         case
                when
                    Quantity >= 8
                then
                    3
                when
                    Quantity > 0
                then
                    2
                else
                    1
            end                           as StockAvailability : Integer,
            ToStockAvailability

    }

}
