//Aca pcreo este fichero , y puedo aumentar o quitar entidades del servicio ODATA externo que cargue

using {sapbackend as external} from './external/sapbackend';

define service SAPBackendExit {
    @cds.persistence: {
        table,
        skip: false
    }
    @cds.autoexpose
    entity Supplier as select from external.Suppliers;
}
