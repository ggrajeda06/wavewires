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
      <h3 class="fw-bold m-0">Servicios Afectados</h3>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
      <div class="w-25">
        <input class="form-control" list="datalistOptions" placeholder="Buscar...">
      </div>
    </div>

    <div class="card shadow-sm">
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-light border-bottom">
              <tr>
                <th scope="col" class="ps-4">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold">
                    Landing(ID) &#x21C5;
                  </button>
                </th>
                <th scope="col">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold">
                    Segmento &#x21C5;
                  </button>
                </th>
                <th scope="col">
                  <button class="btn btn-sm btn-link text-dark text-decoration-none p-0 fw-semibold">
                    Servicios &#x21C5;
                  </button>
                </th>
                <th scope="col" class="text-end pe-4"></th>
              </tr>
            </thead>
            <tbody>
               <tr>
                  <td class="ps-4">Landing 1</td>
                  <td>
                     <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle w-auto text-start"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-popper-config='{"strategy":"fixed"}'
                                aria-expanded="false">
                           Segmentos
                        </button>
                        <ul class="dropdown-menu p-2 shadow-sm">
                           <li class="dropdown-item-text text-dark">Segmento 1</li>
                           <li class="dropdown-item-text text-dark">Segmento 2</li>
                        </ul>
                     </div>
                  </td>
                  <td>
                     <!-- Servicios -->
                     <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle w-auto text-start"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-popper-config='{"strategy":"fixed"}'
                                aria-expanded="false">
                           Servicios
                        </button>
                        <ul class="dropdown-menu p-2 shadow-sm">
                           <li class="dropdown-item-text text-dark">Servicio 5</li>
                           <li class="dropdown-item-text text-dark">Servicio 8</li>
                           <li class="dropdown-item-text text-dark">Servicio 10</li>
                        </ul>
                     </div>
                  </td>
                  <td></td>
               </tr>
               <tr>
                  <td class="ps-4">Landing 2</td>
                  <td>
                     <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle w-auto text-start"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-popper-config='{"strategy":"fixed"}'
                                aria-expanded="false">
                            Segmentos
                        </button>
                        <ul class="dropdown-menu p-2 shadow-sm">
                           <li class="dropdown-item-text text-dark">Segmento 3</li>
                           <li class="dropdown-item-text text-dark">Segmento 4</li>
                        </ul>
                     </div>
                  </td>
                  <td>
                     <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle w-auto text-start"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-popper-config='{"strategy":"fixed"}'
                                aria-expanded="false">
                          Servicios
                        </button>
                        <ul class="dropdown-menu p-2 shadow-sm">
                           <li class="dropdown-item-text text-dark">Servicio 3</li>
                           <li class="dropdown-item-text text-dark">Servicio 2</li>
                        </ul>
                     </div>
                  </td>
                  <td></td>
               </tr>
               <tr>
                  <td class="ps-4">Landing 1</td>
                  <td>
                     <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle w-auto text-start"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-popper-config='{"strategy":"fixed"}'
                                aria-expanded="false">
                           Segmentos
                        </button>
                        <ul class="dropdown-menu p-2 shadow-sm">
                           <li class="dropdown-item-text text-dark">Segmento 5</li>
                           <li class="dropdown-item-text text-dark">Segmento 6</li>
                        </ul>
                     </div>
                  </td>
                  <td>
                     <div class="dropdown">
                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle w-auto text-start"
                                type="button"
                                data-bs-toggle="dropdown"
                                data-bs-popper-config='{"strategy":"fixed"}'
                                aria-expanded="false">
                           Servicios
                        </button>
                        <ul class="dropdown-menu p-2 shadow-sm">
                           <li class="dropdown-item-text text-dark">Servicio 1</li>
                           <li class="dropdown-item-text text-dark">Servicio 4</li>
                           <li class="dropdown-item-text text-dark">Servicio 9</li>
                           <li class="dropdown-item-text text-dark">Servicio 7</li>
                        </ul>
                     </div>
                  </td>
                  <td></td>
               </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
