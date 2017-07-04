<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:include page="loginModal.jsp"></jsp:include>
    <!-- TOPBAR -->
    <div class="top_bar">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <div class="tb_left pull-left">
                        <p><i class="fa fa-phone"></i> 01269645257 &nbsp;&nbsp;&nbsp;<i class="fa fa-envelope-o"></i> hoangnlm84@gmail.com</p>
                    </div>
                    <div class="tb_right pull-right">
                        <ul>
                            <li>
                                <div class="tbr-info">
                                <c:if test="${empty sessionScope.emailUser}">
                                    <span class="fa fa-user">
                                        <a class="fs-login-page" href="#loginModal" data-toggle="modal" data-target="#loginModal">
                                            Login
                                        </a>
                                    </span>
                                    <span class="fa fa-sign-in">
                                        <a class="fs-login-page" href="#registerModal" data-toggle="modal" data-target="#registerModal">
                                            Register
                                        </a>
                                    </span>
                                </c:if>
                                <c:if test="${not empty sessionScope.emailUser}">
                                    <span>${sessionScope.USfirstname} <i class="fa fa-caret-down"></i></span>

                                    <div class="tbr-inner">
                                        <a href="user/myaccount.html">My Account</a>
                                        <a href="user/wishlist/${sessionScope.findUsersID}.html">My Wishlist</a>
                                        <a href="orders/order-history.html">Order History</a>
                                        <a href="logout.html">LogOut</a>
                                    </div>
                                </c:if>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<!--</div>-->

<!--TOPBAR2-->
<div class="topbar2">
    <div class="container">
        <div class="row">
            <div class="col-md-6 logo">
                <!-- Logo -->
                <a class="navbar-brand" href="./index.html"><img src="assets/images/basic/logo4.png" class="img-responsive" alt="Stylish Logo"/></a>
            </div>
            <div class="col-md-2 visible-lg">
                <div class="row banner">
                    <div class="icon">
                        <span class="fa fa-thumbs-up"/>
                    </div>
                    <div class="text">
                        <span class="text1">Original Brands</span><br/>
                        <span class="text2">100% Guaranteed</span>
                    </div>
                </div>
            </div>
            <div class="col-md-2 visible-lg">
                <div class="row banner">
                    <div class="icon">
                        <span class="fa fa-truck"/>
                    </div>
                    <div class="text">
                        <span class="text1">Free Shipping</span><br/>
                        <span class="text2">For $20 Or More</span>
                    </div>
                </div>
            </div>
            <div class="col-md-2 visible-lg">
                <div class="row banner">
                    <div class="icon">
                        <span class="fa fa-refresh"/>
                    </div>
                    <div class="text">
                        <span class="text1">30-Day Returns</span><br/>
                        <span class="text2">Completely Free</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- HEADER -->
<header style="z-index: 1000 !important;">
    <nav class="navbar navbar-default">
        <div class="container">
            <div class="row">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                </div>
                <!-- Cart & Search -->
                <div class="header-xtra pull-right">
                    <div class="topsignal">
                        <span><i class="fa fa-signal"></i></span>
                        <div id="compare">
                            <div class="compare-info">
                                <h3></h3>
                            </div>
                        </div>
                    </div>
                    <div class="topcart">
                        <span><i class="fa fa-shopping-cart"></i></span>
                        <div id="cart">
                        </div>
                        <input id="order-emailUser" name="order-emailUser" type="hidden" value="${sessionScope.emailUser}"/>
                    </div>
                    <div class="topsearch">
                        <span>
                            <i class="fa fa-search"></i>
                        </span>
                        <form class="searchtop">
                            <input type="text" id="fs-search-top-input" placeholder="Search by Product Name...">
                            <div style="background-color: white">
                                <ul id="fs-on-search-result">

                                </ul>
                            </div>
                        </form>

                    </div>

                </div>
                <!-- Navmenu -->
                <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                    <ul class="nav navbar-nav navbar-left">
                        <li>
                            <a href="index.html" class="active">Home</a>
                        </li>
                        <c:forEach items="${cateList}" var="category">
                            <li class="dropdown">
                                <a href="category/${category.cateID}-${category.cateNameNA}.html" 
                                   class="dropdown-toggle" 
                                   data-toggle="dropdown" role="button" 
                                   aria-expanded="false">${category.cateName}</a>
                                <ul class="dropdown-menu submenu" role="menu">
                                    <c:forEach items="${category.subCateList}" var="subCate">
                                        <li><a href="${category.cateNameNA}/${subCate.subCateID}-${subCate.subCateNameNA}.html">${subCate.subCateName}</a></li>
                                        </c:forEach>
                                </ul>
                            </li>
                        </c:forEach>
                        <li class="dropdown">
                            <a href="blog.html" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Blog</a>
                            <ul class="dropdown-menu submenu" role="menu">                     
                                <c:forEach items="${blogCateListClient}" var="blogcateclient">
                                    <li><a href="blog-categories/${blogcateclient.blogCateID}.html">${blogcateclient.blogCateName}</a></li>    
                                    </c:forEach>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
</header>
<script type="text/javascript">
    function deleteItem(productId, sizeId, colorId) {
        $(".topcart").remove("#cart");
        $(".topcart").add("<div id=\"cart\"></div>");
        var productid = productId;
        var sizeid = sizeId;
        var colorid = colorId;
        $.ajax({
            url: "orders/deleteitemCartInHeader.html",
            method: "POST",
            data: {productID: productid, sizeID: sizeid, colorID: colorid},
            dataType: 'html',
            success: function (response) {
                $("#cart").html(response);
            }
        });
    }

    function checkoutClick() {
        var email = $('input[name=order-emailUser]').val();
        if (email == "" || email == null) {
            $("#loginModal").modal("show");
        } else {
            window.location = "orders/checkout.html";
        }
    }

    function cartClearClick() {
        swal({
            title: "Are you sure?",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, clear ALL!",
            cancelButtonText: "No!",
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function (isConfirm) {
            if (isConfirm) {
                $.get("orders/ajax/cart/clear.html", function () {
                    $.get("orders/ajax/cart.html", function (data) {
                        $("#cart").html(data)
                        swal("Deleted!", "Your cart has been clear.", "success")
                    })
                })
            }
        })
    }

    function compareClearClick() {
        swal({
            title: "Are you sure?",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, clear ALL!",
            cancelButtonText: "No!",
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function (isConfirm) {
            if (isConfirm) {
                $.get("compare/ajax/clear.html", function () {
                    $.get("compare/ajax/getCompare.html", function (data) {
                        $("#compare").html(data)
                        swal("Deleted!", "Your compare list has been clear.", "success")
                    })
                })
            }
        })
    }
</script>