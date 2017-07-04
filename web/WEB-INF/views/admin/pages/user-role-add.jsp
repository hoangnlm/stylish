<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Page Content -->
<div id="page-wrapper">
    <div class="container-fluid">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"> 
                    <strong>User Role</strong> 
                    <i class="fa fa-caret-right fa-style" aria-hidden="true" style="color: #FF6699"></i> 
                    <span style="font-size: 0.9em">Create New Roles</span>
                </h1>

            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-lg-12">
                <div class="col-lg-6">
                    <form:form id="fs-form-create-role" action="admin/user/role/create.html" method="post" modelAttribute="role">
                        <p>${error}</p>
                        <div class="form-group">
                            <label>Role Name:</label>
                            <div class="fs-aaa">
                                <form:input cssClass="form-control" path="roleName" id="fs-roleName-create" placeholder="Enter Role Name" />
                            </div>
                            <!--Error Message-->
                            <p class="help-block" id="fs-create-roleName-error"></p>
                        </div>

                        <div class="form-group">
                            <fieldset id="functionList">
                                <legend>Permission Settings</legend>
                                <c:forEach items="${fList}" var="f" varStatus="status">
                                    <div class="checkbox">
                                        <label>
                                            <c:if test="${roleupdate.hasFunction(f.functionID)}">
                                                <input type="checkbox" name="_functionsList" value="${f.functionID}" checked/>
                                            </c:if>
                                            <c:if test="${!roleupdate.hasFunction(f.functionID)}">
                                                <input type="checkbox" name="_functionsList" value="${f.functionID}"/>
                                            </c:if>
                                            ${f.functionName}
                                        </label>
                                    </div>
                                </c:forEach>
                            </fieldset>
                        </div>

                        <button type="submit" id="fs-button-create-role" class="btn btn-success"><i class="fa fa-plus"></i> Create</button>
                        <button type="reset" class="btn btn-default"><i class="fa fa-repeat"></i> Reset</button>
                    </form:form>
                </div>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
    </div>
    <!-- /.container-fluid -->
</div>
<!-- /#page-wrapper -->