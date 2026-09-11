<%--
  Created by IntelliJ IDEA.
  User: davil
  Date: 11/09/2026
  Time: 13:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="card mb-4">
    <div class="card-body">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="card-title mb-0">Capacidad de la red</h5>

            <a class="btn btn-outline-secondary btn-sm"
               href="${pageContext.request.contextPath}/reportes_supervisor.jsp">
                Más detalles
            </a>
        </div>

        <div class="row g-3 mb-4">

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="border rounded p-3 h-100">
                    <small>Capacidad total</small>
                    <p class="fs-5 text-center mb-0">3300 Gbps</p>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="border rounded p-3 h-100">
                    <small>Capacidad en uso</small>
                    <p class="fs-5 text-center mb-0">2000 Gbps</p>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="border rounded p-3 h-100">
                    <small>Capacidad reservada</small>
                    <p class="fs-5 text-center mb-0">200 Gbps</p>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="border rounded p-3 h-100">
                    <small>Capacidad disponible</small>
                    <p class="fs-5 text-center mb-0">1100 Gbps</p>
                </div>
            </div>

        </div>

        <div class="border rounded p-3">
            <h5 class="mb-3">Más utilizados</h5>

            <div class="row g-4">

                <div class="col-12 col-md-6">

                    <div class="row align-items-center mb-2">
                        <div class="col-4">Segmento 1</div>
                        <div class="col-6">
                            <div class="progress">
                                <div class="progress-bar bg-secondary"
                                     style="width: 97%"></div>
                            </div>
                        </div>
                        <div class="col-2">97%</div>
                    </div>

                    <div class="row align-items-center mb-2">
                        <div class="col-4">Segmento 2</div>
                        <div class="col-6">
                            <div class="progress">
                                <div class="progress-bar bg-secondary"
                                     style="width: 96%"></div>
                            </div>
                        </div>
                        <div class="col-2">96%</div>
                    </div>

                    <div class="row align-items-center">
                        <div class="col-4">Segmento 3</div>
                        <div class="col-6">
                            <div class="progress">
                                <div class="progress-bar bg-secondary"
                                     style="width: 93%"></div>
                            </div>
                        </div>
                        <div class="col-2">93%</div>
                    </div>

                </div>

                <div class="col-12 col-md-6">

                    <div class="row align-items-center mb-2">
                        <div class="col-4">Segmento 4</div>
                        <div class="col-6">
                            <div class="progress">
                                <div class="progress-bar bg-secondary"
                                     style="width: 85%"></div>
                            </div>
                        </div>
                        <div class="col-2">85%</div>
                    </div>

                    <div class="row align-items-center mb-2">
                        <div class="col-4">Segmento 5</div>
                        <div class="col-6">
                            <div class="progress">
                                <div class="progress-bar bg-secondary"
                                     style="width: 82%"></div>
                            </div>
                        </div>
                        <div class="col-2">82%</div>
                    </div>

                    <div class="row align-items-center">
                        <div class="col-4">Segmento 6</div>
                        <div class="col-6">
                            <div class="progress">
                                <div class="progress-bar bg-secondary"
                                     style="width: 75%"></div>
                            </div>
                        </div>
                        <div class="col-2">75%</div>
                    </div>

                </div>

            </div>
        </div>

    </div>
</section>