const cds = require("@sap/cds");

const { Orders } = cds.entities("com.training");

module.exports = (srv) => {
  //************READ****************/
  srv.on("READ", "GetOrders", async (req) => {
    if (req.data.ClientEmail !== undefined) {
      return await SELECT.from`com.training.Orders`
        .where`ClientEmail = ${req.data.ClientEmail}`;
    }
    return SELECT.from(Orders);
  });

   //*****CREATE ******/
   srv.on("CREATE", "CreateOrder", async (req) => {
    try {
      const result = await cds.transaction(req).run(
        INSERT.into(Orders).entries({
          ClientEmail: req.data.ClientEmail,
          FirstName: req.data.FirstName,
          LastName: req.data.LastName,
          CreatedOn: req.data.CreatedOn,
          Reviewed: req.data.Reviewed,
          Approved: req.data.Approved,
          Country_code: req.data.Country_code,
        })
      );

      if (result) {
        console.log("Registro Insertado:", result);
        return req.data;
      } else {
        req.error(409, "Registro No Insertado");
      }
    } catch (err) {
      console.error(err);
      req.error(err.code, err.message);
    }
  });

   /**
   * me sirve para que genere la fecha actual, automatico en el objeto y modifica la fecha de ""CreatedOn"" a fecha actual
   */
   srv.before("CREATE", "CreateOrder", (req) => {
    req.data.CreatedOn = new Date().toISOString().slice(0, 10);
    return req;
  });

    //*****UPDATE ******/
    srv.on("UPDATE", "UpdateOrder", async (req) => {
      let returData = await cds
        .transaction(req)
        .run([
          UPDATE(Orders, req.data.ClientEmail).set({
            FirstName: req.data.FirstName,
            LastName: req.data.LastName,
          }),
        ])
        .then((resolve, reject) => {
          console.log("Resolve: ", resolve);
          console.log("Reject: ", reject);
  
          if (resolve[0] == 0) {
            req.error(409, "Registro No Encontrado");
          }
        })
        .catch((err) => {
          console.log(err);
          req.error(err.code, err.message);
        });
      return returData;
    });

     //*****FUCTION ******/
  srv.on("getClientTaxRate", async (req) => {
    try {
      const { clientEmail } = req.data;
      const db = srv.transaction(req);

      const results = await db
        .read(Orders, ["Country_code"])
        .where({ ClientEmail: clientEmail });

      if (results && results[0] && results[0].Country_code) {
        switch (results[0].Country_code) {
          case "ES":
            return 21.5;
          case "UK":
            return 24.6;
          default:
            break;
        }
      } else {
        // Manejar el caso donde no se encuentra el país o no hay resultados.
        console.error("No se encontró el país para el cliente:", clientEmail);
        return 0; // O el valor predeterminado que desees
      }
    } catch (error) {
      console.error("Error al obtener el país del cliente:", error);
      return 0; // O el valor predeterminado que desees
    }
  });

  //*****ACTION ******/
  srv.on("cancelOrder", async (req) => {
    const { clientEmail } = req.data;
    const db = srv.transaction(req);

    const resultRead = await db
      .read(Orders, ["FirstName", "LastName", "Approved"])
      .where({ ClientEmail: clientEmail });

    let returnOrder = {
      status: "",
      message: "",
    };

    console.log(clientEmail);
    console.log(resultRead);

    if (resultRead[0].Approved == false) {
      const resultUpdate = await db
        .update(Orders)
        .set({ Status: "C" })
        .where({ ClientEmail: clientEmail });
        returnOrder.status = "Succeded";
        returnOrder.message = `El Pedido Realizado Por ${resultRead[0].FirstName}  ${resultRead[0].LastName} Fue Cancelado`;
    } else {
      returnOder.status = "Failed";
      returnOder.message = `El Pedido Realizado Por ${resultRead[0].FirstName}  ${resultRead[0].LastName} no fue cancelado porque ya estaba aprobado`;
    }
    console.log("Accion De Cancelar Order Ejecutada");
    return returnOrder;
  });

};