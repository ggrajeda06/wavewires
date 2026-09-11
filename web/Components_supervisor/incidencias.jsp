<%--
  Created by IntelliJ IDEA.
  User: davil
  Date: 11/09/2026
  Time: 13:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="card h-100">
    <div class="card-body">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="card-title mb-0">Incidencias activas</h5>

            <a class="btn btn-outline-secondary btn-sm"
               href="${pageContext.request.contextPath}/reportes_supervisor.jsp">
                Más detalles
            </a>
        </div>

        <div class="table-responsive">
            <table class="table table-sm align-middle">
                <thead>
                    <tr>
                        <th>Segmento afectado</th>
                        <th>Estado</th>
                        <th>Severidad</th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td>Landing-A</td>
                        <td>En análisis</td>
                        <td>Crítica</td>
                    </tr>

                    <tr>
                        <td>Landing-B</td>
                        <td>En atención</td>
                        <td>Alta</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>
</section>
