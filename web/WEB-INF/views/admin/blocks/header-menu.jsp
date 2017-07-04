<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- Navigation -->
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="index.html" target="_blank"><img src="assets/images/basic/logo2.png" alt="Stylish Store" height="34"/></a>

    </div>
    <!-- /.navbar-header -->

    <ul class="nav navbar-top-links navbar-right">
        <li><a href="admin/logout.html"><i class="fa fa-sign-out fa-fw"></i>Logout</a>
    </ul>
    <!-- /.navbar-top-links -->

    <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse">
            <ul class="nav" id="side-menu">
                <c:forEach items="${sessionScope.fList}" var="f">
                    <c:choose>
                        <c:when test="${f.functionName eq 'User Roles'}">
                            <li>
                                <a href="#"><i class="fa fa-key fa-fw"></i> User Roles<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/user/role/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/user/role.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Users'}">
                            <li>
                                <a href="#"><i class="fa fa-users fa-fw"></i> Users<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/user/list.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>

                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Product Categories'}">
                            <li>
                                <a href="#"><i class="fa fa-cube fa-fw"></i> Product Categories<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/product-category/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/product-category.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Product Subcategories'}">
                            <li>
                                <a href="#"><i class="fa fa-cubes fa-fw"></i> Product Subcategories<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/product-subcategory/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/product-subcategory.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Products'}">
                            <li>
                                <a href="#"><i class="fa fa-diamond fa-fw"></i> Products<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/product/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/product.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Orders'}">
                            <li>
                                <a href="#"><i class="fa fa-shopping-cart fa-fw"></i> Orders<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/orders/list.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                    <li>
                                        <a href="admin/orders/orderchart.html"><i class="fa fa-list" aria-hidden="true"></i> Statistics</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Discounts'}">
                            <li>
                                <a href="#"><i class="fa fa-shopping-cart fa-fw"></i> Discounts<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/orders/discountadd.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/orders/discountlist.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Comments'}">
                            <li>
                                <a href="#"><i class="fa fa-gear fa-fw"></i> Comments<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/comment/view.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Blog Categories'}">
                            <li>
                                <a href="#"><i class="fa fa-thumb-tack fa-fw"></i> Blog Categories<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/blog/category/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/blog/category.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>

                        <c:when test="${f.functionName eq 'Blogs'}">
                            <li>
                                <a href="#"><i class="fa fa-newspaper-o fa-fw"></i> Blogs<span class="fa arrow"></span></a>
                                <ul class="nav nav-second-level">
                                    <li>
                                        <a href="admin/blog/create.html"><i class="fa fa-plus" aria-hidden="true"></i> New</a>
                                    </li>
                                    <li>
                                        <a href="admin/blog/list.html"><i class="fa fa-list" aria-hidden="true"></i> List</a>
                                    </li>
                                    <li>
                                        <a href="admin/blog/listchartblog.html"><i class="fa fa-list" aria-hidden="true"></i> Statistics</a>
                                    </li>
                                </ul>
                                <!-- /.nav-second-level -->
                            </li>
                        </c:when>
                    </c:choose>
                </c:forEach>
            </ul>
        </div>
        <!-- /.sidebar-collapse -->
    </div>
    <!-- /.navbar-static-side -->
</nav>