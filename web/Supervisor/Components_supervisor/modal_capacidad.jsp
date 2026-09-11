<%--
  Created by IntelliJ IDEA.
  User: davil
  Date: 11/09/2026
  Time: 13:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="modal fade"
     id="modalCapacidad"
     tabindex="-1"
     aria-labelledby="tituloModalCapacidad"
     aria-hidden="true">

    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">

        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="tituloModalCapacidad">
                    Capacidad de la red
                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Cerrar">
                </button>
            </div>

            <div class="modal-body">

                <!-- Resumen de capacidad -->
                <div class="row g-3 mb-4">

                    <div class="col-12 col-md-3">
                        <div class="border rounded p-3 text-center">
                            <small>Capacidad total</small>
                            <p class="fs-5 mb-0">3300 Gbps</p>
                        </div>
                    </div>

                    <div class="col-12 col-md-3">
                        <div class="border rounded p-3 text-center">
                            <small>Capacidad en uso</small>
                            <p class="fs-5 mb-0">2000 Gbps</p>
                        </div>
                    </div>

                    <div class="col-12 col-md-3">
                        <div class="border rounded p-3 text-center">
                            <small>Capacidad reservada</small>
                            <p class="fs-5 mb-0">200 Gbps</p>
                        </div>
                    </div>

                    <div class="col-12 col-md-3">
                        <div class="border rounded p-3 text-center">
                            <small>Capacidad disponible</small>
                            <p class="fs-5 mb-0">1100 Gbps</p>
                        </div>
                    </div>

                </div>

                <!-- Buscador -->
                <input type="search"
                       class="form-control mb-3"
                       placeholder="Buscar segmento">

                <!-- Tabla detallada -->
                <div class="table-responsive">
                    <table class="table align-middle">

                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Ruta</th>
                                <th>Total</th>
                                <th>En uso</th>
                                <th>Disponible</th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr>
                                <td>Segmento 1</td>
                                <td>Perú - EE. UU.</td>
                                <td>600 Gbps</td>
                                <td>100 Gbps</td>
                                <td>500 Gbps</td>
                            </tr>

                            <tr>
                                <td>Segmento 2</td>
                                <td>Perú - España</td>
                                <td>500 Gbps</td>
                                <td>400 Gbps</td>
                                <td>100 Gbps</td>
                            </tr>

                            <tr>
                                <td>Segmento 3</td>
                                <td>Perú - Japón</td>
                                <td>500 Gbps</td>
                                <td>370 Gbps</td>
                                <td>130 Gbps</td>
                            </tr>
                        </tbody>

                    </table>
                </div>

            </div>

            <div class="modal-footer">

                <button type="button"
                        class="btn btn-outline-secondary"
                        data-bs-dismiss="modal">
                    Cerrar
                </button>

                <a class="btn btn-outline-secondary"
                   href="${pageContext.request.contextPath}/reportes_supervisor.jsp">
                    Reportar
                </a>

            </div>

        </div>
    </div>
</div>