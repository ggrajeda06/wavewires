<%--
  Created by IntelliJ IDEA.
  User: davil
  Date: 11/09/2026
  Time: 13:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="card h-100">
    <div class="card-body">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="card-title mb-0">Mantenimientos pendientes</h5>

            <a class="btn btn-outline-secondary btn-sm"
               href="${pageContext.request.contextPath}/reportes_supervisor.jsp">
                Más detalles
            </a>
        </div>

        <div class="table-responsive">
            <table class="table table-sm align-middle">
                <thead>
                    <tr>
                        <th>Segmento</th>
                        <th>Tipo</th>
                        <th>Fecha</th>
                    </tr>
                </thead>

                <tbody>
                    <tr>
                        <td>ID1 - Landing-A</td>
                        <td>Correctivo</td>
                        <td>10/10/2026</td>
                    </tr>

                    <tr>
                        <td>ID2 - Landing-B</td>
                        <td>Preventivo</td>
                        <td>15/10/2026</td>
                    </tr>

                    <tr>
                        <td>ID3 - Landing-C</td>
                        <td>Correctivo</td>
                        <td>20/10/2026</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </div>
</section>