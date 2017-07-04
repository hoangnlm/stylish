<%@page import="stylish.entity.CartLineInfo"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true" />

<!-- MAIN CONTENT -->
<c:if test="${empty compareList}">
    <h4 style="font-weight: bold; background-color: #FFFFFF; padding: 30px; text-align: center; font-size: 30px; line-height: 50px;">Please choose some products to compare! <br/><a style="cursor: pointer;" href="index.html">Continue shopping...</a>
    </h4>
</c:if>

<c:if test="${not empty compareList}">
    <div class="compare-table">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12">
                    <form method="GET" action="compare/deleteAll.html" id="compare-clear-all">
                        <button type="submit" style="margin-left: 20px;" class="btn-black pull-right">Clear all</button>
                        <a href="index.html" class="pull-right"><button class="btn-black">Back to shopping</button></a>
                    </form
                </div>
            </div>
        </div>
        <section class="cd-products-comparison-table">
            <div class="cd-products-table">
                <div class="features">
                    <div class="top-info">Models</div>
                    <ul class="cd-features-list">
                        <li>Price</li>
                        <li>Discount</li>
                        <li>Posted Date</li>
                        <li>Views</li>
                    </ul>
                </div> <!-- .features -->

                <div class="cd-products-wrapper">
                    <ul class="cd-products-columns">

                        <c:forEach items="${compareList}" var="item">
                            <li class="product" id="fs-compare-del-${item.productID}">
                                <div class="top-info">
                                    <a class="fs-compare-del" fs-compare-del-id="${item.productID}"><span style="font-size: 40px;text-align: center;">&times;</span></a>
                                    <div class="compare-img">
                                        <img src="assets/images/products/${item.urlImg}" alt="product image" style="max-height: 100px;">
                                    </div>                            
                                    <h3>${item.productName}</h3>
                                </div> <!-- .top-info -->

                                <ul class="cd-features-list">
                                    <li>${item.price}</li>
                                    <li>${item.productDiscount}</li>
                                    <li><fmt:formatDate pattern="MM/dd/yyyy" value="${item.postedDate}"/></li>
                                    <li>${item.productViews}</li>
                                </ul>
                            </li> <!-- .product -->
                        </c:forEach>

                    </ul> <!-- .cd-products-columns -->
                </div> <!-- .cd-products-wrapper -->

                <ul class="cd-table-navigation">
                    <li><a href="#0" class="prev inactive">Prev</a></li>
                    <li><a href="#0" class="next">Next</a></li>
                </ul>
            </div> <!-- .cd-products-table -->
        </section> <!-- .cd-products-comparison-table -->
    </div>
</c:if>

<!-- MODAL -->
<jsp:include page="../blocks/modal.jsp" flush="true" />