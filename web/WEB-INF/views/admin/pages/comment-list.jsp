<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>Comment</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #FF6699"></i> 
                    <span style="font-size: 0.9em">List</span>
                </h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->

        <div class="row">
            <div class="col-lg-12">
                <table width="100%" class="table table-striped table-bordered table-hover" id="comment-dataTables">
                    <thead>
                        <tr>
                            <th align="center"></th>
                            <td align="center">No</td>
                            <td align="center">Product Name</td>
                            <td align="center">User Name</td>
                            <td align="center">Posted Date</td>
                            <td align="center">Comment</td>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${ratingList}" var="ratingItem" varStatus="no">
                            <tr class="odd gradeX" >
                                <td align="center">
                                    <input 
                                        id="${ratingItem.ratingID}" 
                                        ratingStatus="${ratingItem.status}" 
                                        class="bs-toggle"
                                        type="checkbox" 
                                        <c:if test="${ratingItem.status == 1}">
                                            checked
                                        </c:if> 
                                        data-toggle="toggle"  
                                        data-onstyle="primary" 
                                        data-offstyle="danger"/>
                                </td>
                                <td class="center" align="center">${no.index + 1}</td>
                                <td class="center" align="center">${ratingItem.product.productName}</td>
                                <td class="center" align="center">${ratingItem.user.fullName}</td>
                                <td class="center" align="center">
                                    <fmt:formatDate pattern="MM/dd/yyyy" value="${ratingItem.ratingDate}"/>
                                </td>
                                <td class="center" align="center">${ratingItem.review}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <!-- /.table-responsive -->
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->

<script>
    $(function () {
        $('.bs-toggle').bootstrapToggle();
    })
</script>
