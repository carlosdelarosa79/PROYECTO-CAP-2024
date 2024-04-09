using com.training as training from '../db/training';

service ManageOrders {

    type cancelOrderReturn {
        status  : String enum {
            Succeded;
            Failed
        };
        message : String
    };

    entity Orders as projection on training.Orders actions {
                         function getClientTaxRate(ClientEmail : String) returns Decimal(4, 2);
                         action   cancelOrder(ClientEmail : String)      returns cancelOrderReturn;
                     }


}

//entity GetOrders   as projection on training.Orders;
//entity CreateOrder as projection on training.Orders;
//entity UpdateOrder as projection on training.Orders;
