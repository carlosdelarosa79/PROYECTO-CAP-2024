using {proyecto.personal as carlos} from '../db/schema';
//using {proyecto.training as training} from '../db/training';

/**
 * aca exponemos las entidades que hicimos en  "schema.cds"  asi va aparecer en la interface usuario en nuestro localhost
 */

//service CatalogService {
//    entity Products          as projection on carlos.materials.Products;
//    entity Suppliers         as projection on carlos.sales.Suppliers
//    entity Currency          as projection on carlos.materials.Currencies;
//    entity DimensionsUnit    as projection on carlos.materials.DimensionsUnits;
//    entity Category          as projection on carlos.materials.Categories;
//    entity SalesData         as projection on carlos.sales.SalesData;
//    entity Reviews           as projection on carlos.materials.ProductReview;
//    entity UnitOfMeasures    as projection on carlos.materials.UnitOfMeasures;
//    entity Months            as projection on carlos.sales.Months;
//    entity Orders            as projection on carlos.sales.Orders;
//    entity OrderItem         as projection on carlos.sales.OrderItems;
//}

define service CatalogService {
    entity Products          as
        select from carlos.reports.Products {
            ID,
            Name           as ProductName     @mandatory,
            Description                       @mandatory,
            ImageUrl,
            ReleaseDate,
            DiscontinuedDate,
            Price                             @mandatory,
            Height,
            Width,
            Depth,
            Quantity                          @(
                andatory,
                assert.range: [
                    0.00,
                    20
                ]
            ),
            UnitOfMeasure  as ToUnitOfMeasure @mandatory,
            Currency       as ToCurrency      @mandatory,
            Category.Name  as ToCategory      @readonly,
            DimensionsUnit as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews,
            Rating,
            StockAvailability,
            ToStockAvailability
        };

    @readonly
    entity Suppliers         as
        select from carlos.sales.Suppliers {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from carlos.materials.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            createdAt,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from carlos.sales.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth             as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonth,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from carlos.materials.StockAvailability {
            ID,
            Description,
            Product as ToProduct
        };

    @readonly
    entity VH_Categories     as
        select from carlos.materials.Categories {
            ID   as Code,
            Name as Text
        };

    @readonly
    entity VH_Currencies     as
        select from carlos.materials.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from carlos.materials.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as
        select
            ID          as Code,
            Description as Text
        from carlos.materials.DimensionsUnits;

}

define service MyService {

    entity SuppliersProduct  as
        select from carlos.materials.Products[Name = 'Bread']{
            *,
            Name,
            Description,
            Products.Supplier
        };

    entity SuppliersToSales  as select Products.Name from carlos.materials.Products;
    entity EntityInfix       as select Supplier from carlos.materials.Products
}

define service reports {
    entity AverageRating     as projection on carlos.reports.AverageRating;

    entity EntityCasting     as
        select
            cast(
                Price as      Integer
            )     as Price,
            Price as Price2 : Integer
        from carlos.materials.Products;

    entity EntityExists as select
    from carlos.materials.Products {
        Name
    }

}
