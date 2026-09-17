<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <title>OceanLink</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="row g-0">
  <jsp:include page="sidebarMantenimiento.jsp"/>
  <main class="col p-4 bg-light">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h3 class="fw-bold m-0">Historial de Mantenimiento</h3>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <div class="w-25">
        <input class="form-control" list="datalistOptions" placeholder="Buscar...">
        <datalist id="datalistOptions">
          <option value="ID1 - Landing-A ">
          <option value="ID2 - Landing-B ">
          <option value="ID3 - Landing-C ">
        </datalist>
      </div>
      <a class="btn btn-outline-secondary" href="registrarMantenimiento.jsp">Registrar mantenimiento</a>
    </div>

    <!-- Tarjeta Contenedora Principal -->
    <div class="card shadow-sm">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th scope="col" class="ps-4">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" >
                    Nombre del servicio(ID) &#x21C5;
                  </button>
                </th>
                <th scope="col">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" >
                    Estado &#x21C5;
                  </button>
                </th>
                <th scope="col">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" >
                    Fecha &#x21C5;
                  </button>
                </th>
                <th scope="col">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" >
                    Infraestructura &#x21C5;
                  </button>
                </th>
                <th scope="col">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold" >
                    Ubicación &#x21C5;
                  </button>
                </th>
                <th scope="col" class="text-end pe-4"></th>
              </tr>
            </thead>
            <tbody id="tablaCuerpo">
              <tr>
                <!-- Nombre convertido en enlace interactivo para abrir el modal -->
                <td class="ps-4">
                  <a href="#" class="text-decoration-none fw-bold" onclick="mostrarDetalle('ID1 - Landing-A', 'activo', 'Mantenimiento preventivo de fibra ópticaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'Preventivo', '10/10/2000', 'Landing Station A', 'Revisión técnica completa de conectores.')">
                    ID1 - Landing-A
                  </a>
                </td>
                <td><span class="badge bg-success">activo</span></td>
                <td>10/10/2000</td>
                <td>Landing Station A</td>
                <td>Lima, PE</td>
                <td class="text-end pe-4">
                  <button class="btn btn-link text-dark text-decoration-none fw-bold">•••</button>
                </td>
              </tr>
              <tr>
                <td class="ps-4">
                  <a href="#" class="text-decoration-none fw-bold" onclick="mostrarDetalle('ID2 - Landing-B', 'pendiente', 'Inspección de enlace submarino', 'Correctivo', '10/10/2000', 'Landing Station B', 'Espera de repuestos de empalme.')">
                    ID2 - Landing-B
                  </a>
                </td>
                <td><span class="badge bg-warning text-dark">pendiente</span></td>
                <td>10/10/2000</td>
                <td>Landing Station B</td>
                <td>Lima, PE</td>
                <td class="text-end pe-4">
                  <button class="btn btn-link text-dark text-decoration-none fw-bold">•••</button>
                </td>
              </tr>
              <tr>
                <td class="ps-4">
                  <a href="#" class="text-decoration-none fw-bold" onclick="mostrarDetalle('ID3 - Landing-C', 'finalizado', 'Calibración de repetidores', 'Rutina', '10/10/2000', 'Landing Station C', 'Ajuste de ganancia finalizado.')">
                    ID3 - Landing-C
                  </a>
                </td>
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

      <div class="card-footer bg-white d-flex justify-content-end gap-2 py-3 border-top-0">
        <button class="btn btn-outline-secondary btn-sm">Anterior</button>
        <button class="btn btn-outline-secondary btn-sm">Siguiente</button>
      </div>
    </div>
  </main>
</div>

<!-- MODAL INFORMACIÓN (Basado en tu bosquejo, no modificable) -->
<div class="modal fade" id="modalDetalle" tabindex="-1" aria-labelledby="modalDetalleLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header border-bottom-0 pb-0">
        <h4 class="modal-title w-100 text-center fw-bold" id="modalDetalleLabel">INFORMACIÓN</h4>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4">
        <div class="row g-3">
          <!-- Columna Izquierda / Central -->
          <div class="col-md-7">
            <div class="row g-3">
              <div class="col-6">
                <label class="form-label small fw-semibold">Name</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoNombre"></div>
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold">Estado</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoEstado"></div>
              </div>
              <div class="col-12">
                <label class="form-label small fw-semibold">Descripción</label>
                <!-- Evita que el texto salga y genera scroll si pasa de 120px -->
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoDescripcion" style="max-height: 120px; overflow-y: auto;"></div>
              </div>
              <div class="col-12">
                <label class="form-label small fw-semibold">Tipo de mantenimiento</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoTipo"></div>
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold">Fecha</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoFecha"></div>
              </div>
              <div class="col-6">
                <label class="form-label small fw-semibold">Infraestructura</label>
                <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break" id="infoInfraestructura"></div>
              </div>
            </div>
          </div>

          <!-- Columna Derecha (Actividades Realizadas) -->
          <div class="col-md-5 d-flex flex-column">
            <label class="form-label small fw-semibold text-uppercase" style="font-size: 0.75rem;">
              ACTIVIDADES REALIZADAS DURANTE EL MANTENIMIENTO:
            </label>
            <!-- Mantiene el tamaño fijo de la tarjeta y añade barra de desplazamiento limpia si el texto es extenso -->
            <div class="form-control-plaintext border rounded px-3 py-2 bg-light text-dark text-break flex-grow-1" id="infoActividades" style="max-height: 250px; overflow-y: auto;"></div>
          </div>
        </div>
      </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
// Función para cargar los datos en el modal y desplegarlo
function mostrarDetalle(nombre, estado, descripcion, tipo, fecha, infraestructura, actividades) {
  document.getElementById('infoNombre').textContent = nombre;
  document.getElementById('infoEstado').textContent = estado;
  document.getElementById('infoDescripcion').textContent = descripcion;
  document.getElementById('infoTipo').textContent = tipo;
  document.getElementById('infoFecha').textContent = fecha;
  document.getElementById('infoInfraestructura').textContent = infraestructura;
  document.getElementById('infoActividades').textContent = actividades;

  let modal = new bootstrap.Modal(document.getElementById('modalDetalle'));
  modal.show();
}


</script>
</body>
</html>
