using {proyecto.personal as carlos} from '../db/schema';

service CustomerService {
    entity CustomerService as projection on carlos.Customer
}
