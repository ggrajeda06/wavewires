<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>WaveWires</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="MC_sidebar.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold m-0">Historial de Mantenimiento</h3>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <div class="w-25">
        <input type="text" class="form-control" placeholder="(Para buscar)">
      </div>
      <button class="btn btn-outline-secondary" ><a class="nav-link" href="registrarMantenimiento.jsp">Registrar mantenimiento</a></button>
    </div>

    <!-- Tarjeta Contenedora Principal -->
    <div class="card shadow-sm">
      <div class="card-body p-0">
            <div class="table-responsive">
              <table class="table table-hover align-middle mb-0">
                <!-- Encabezado de tabla interactivo para ordenar -->
                <thead class="table-light border-bottom">
                  <tr>
                    <th scope="col" class="ps-4">
                      <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" onclick="sortTable(0)">
                        Nombre del servicio(ID) &#x21C5;
                      </button>
                    </th>
                    <th scope="col">
                      <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" onclick="sortTable(1)">
                        Estado &#x21C5;
                      </button>
                    </th>
                    <th scope="col">
                      <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" onclick="sortTable(2)">
                        Fecha &#x21C5;
                      </button>
                    </th>
                    <th scope="col">
                      <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" onclick="sortTable(3)">
                        Infraestructura &#x21C5;
                      </button>
                    </th>
                    <th scope="col">
                      <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" onclick="sortTable(4)">
                        Ubicación &#x21C5;
                      </button>
                    </th>
                    <th scope="col" class="text-end pe-4"></th>
                  </tr>
                </thead>
                <tbody id="tablaCuerpo">
                  <tr>
                    <td class="ps-4">ID1 - Landing-A</td>
                    <td><span class="badge bg-success">activo</span></td>
                    <td>10/10/2000</td>
                    <td>Landing Station A</td>
                    <td>Lima, PE</td>
                    <td class="text-end pe-4">
                      <button class="btn btn-link text-dark text-decoration-none fw-bold">•••</button>
                    </td>
                  </tr>
                  <tr>
                    <td class="ps-4">ID2 - Landing-B</td>
                    <td><span class="badge bg-warning text-dark">pendiente</span></td>
                    <td>10/10/2000</td>
                    <td>Landing Station B</td>
                    <td>Lima, PE</td>
                    <td class="text-end pe-4">
                      <button class="btn btn-link text-dark text-decoration-none fw-bold">•••</button>
                    </td>
                  </tr>
                  <tr>
                    <td class="ps-4">ID3 - Landing-C</td>
                    <td><span class="badge bg-secondary">finalizado</span></td>
                    <td>10/10/2000</td>
                    <td>Landing Station C</td>
                    <td>Lima, PE</td>
                    <td class="text-end pe-4">
                      <button class="btn btn-link text-dark text-decoration-none fw-bold">•••</button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

      <!-- Paginación / Botones de navegación -->
      <div class="card-footer bg-white d-flex justify-content-end gap-2 py-3 border-top-0">
        <button class="btn btn-outline-secondary btn-sm">Anterior</button>
        <button class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function sortTable(n) {
  let table = document.querySelector("table");
  let rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  switching = true;
  dir = "asc";
  while (switching) {
    switching = false;
    rows = table.rows;
    for (i = 1; i < (rows.length - 1); i++) {
      shouldSwitch = false;
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      if (dir == "asc") {
        if (x.innerText.toLowerCase() > y.innerText.toLowerCase()) {
          shouldSwitch = true;
          break;
        }
      } else if (dir == "desc") {
        if (x.innerText.toLowerCase() < y.innerText.toLowerCase()) {
          shouldSwitch = true;
          break;
        }
      }
    }
    if (shouldSwitch) {
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      switchcount++;
    } else {
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}
</script>
</body>
</html>
