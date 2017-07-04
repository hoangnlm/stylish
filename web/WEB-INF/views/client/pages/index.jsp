<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!--FLEXSLIDER-->
<div class="block-main container">
    <div class="row row-eq-height">
        <div class="col-md-8">
            <div class="fslider shadow1" data-arrows="false">
                <div class="flexslider">
                    <ul class="slides">
                        <!--Slider images-->
                        <li>
                            <a href="#">
                                <img src="assets/images/flex_slider/1.jpg" alt="Shop Image">
                            </a>
                        </li>

                        <li>
                            <a href="#">
                                <img src="assets/images/flex_slider/2.jpg" alt="Shop Image">
                            </a>
                        </li>

                        <li>
                            <a href="#">
                                <img src="assets/images/flex_slider/3.jpg" alt="Shop Image">
                            </a>
                        </li>

                        <li>
                            <a href="#">
                                <img src="assets/images/flex_slider/4.jpg" alt="Shop Image">
                            </a>
                        </li>

                        <li>
                            <a href="#">
                                <img src="assets/images/flex_slider/5.jpg" alt="Shop Image">
                            </a>
                        </li>

                        <li>
                            <a href="#">
                                <img src="assets/images/flex_slider/6.jpg" alt="Shop Image">
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(document).ready(function () {
                $('.flexslider').flexslider({
                    animation: "slide",
                    directionNav: false,
                    pauseOnAction: false,
                    slideshowSpeed: 4000,
                    animationSpeed: 2000
                });
            });
        </script>

        <div class="col-md-4 top-right-banner-box">
            <div class="row top-right-banner">
                <a href="#"><img class="border1" src="assets/images/banners/7.jpg" alt="Shop Image"></a>
            </div>

            <div class="row top-right-banner">
                <a href="#"><img class="border1" src="assets/images/banners/3.jpg" alt="Shop Image"></a>
            </div>
        </div>
    </div>
</div>

<!-- BLOCKS WRAP -->
<div class="block-main container">
    <div class="row">
        <div class="col-md-4 col-sm-4">
            <div class="block-content shadow1">
                <img src="assets/images/blocks/9_1.jpg" class="img-responsive" alt=""/>
                <div class="bs-text-down text-center hvr-outline-out">
                    Cool Dress<span>Intimates Summer 2017</span>				
                </div>
            </div>
        </div>
        <div class="col-md-4 col-sm-4">
            <div class="block-content shadow1">
                <img src="assets/images/blocks/10_1.jpg" class="img-responsive" alt=""/>
                <div class="bs-text-down text-center">
                    Fascinating<span>Get a new look with Smile Collection</span>			
                </div>
            </div>
        </div>
        <div class="col-md-4 col-sm-4">
            <div class="block-content shadow1">
                <img src="assets/images/blocks/3.jpg" class="img-responsive" alt=""/>
                <div class="bs-text-down text-center">
                    Characteristic<span>Tatoo Collection new arrivals</span>				
                </div>
            </div>
        </div>
    </div>
</div>

<div class="clearfix"></div>

<!-- FEATURED PRODUCTS -->
<div class="featured-products">
    <div class="container">
        <div class="row">
            <h5 class="heading"><span>Featured Products</span></h5>
            <ul class="filter" data-option-key="filter">
                <li><a class="selected" href="#filter" data-option-value=".isotope_to_all">All</a></li>
                    <c:forEach items="${cateList}" var="cate" varStatus="no"> 
                    <li>
                        <a href="#" data-option-value=".${cate.cateName}">${cate.cateName}</a>
                    </li>
                </c:forEach>
            </ul>
            <div id="isotope" class="isotope">
                <c:forEach items="${cateList}" var="cate">
                    <c:forEach items="${cate.productListWorking}" var="product" begin="0" end="7" varStatus="no">
                        <div class="isotope-item ${cate.cateName} <c:if test="${no.index % 2 == 0}">isotope_to_all</c:if>">
                                <div class="product-item">
                                    <div class="item-thumb">
                                    <c:if test="${product.productDiscount > 0}">
                                        <div class="badge offer">-${product.productDiscount}%</div>
                                    </c:if>
                                    <img src="assets/images/products/${product.urlImg}"
                                         class="img-responsive" 
                                         alt="${product.urlImg}"
                                         fs-product-for-img="${product.productID}"/>
                                    <div class="overlay-rmore fa fa-search quickview fs-product-modal" 
                                         fs-product="${product.productID}" 
                                         fs-product-modal-color="${product.productColorListWorking[0].colorID}" 
                                         data-toggle="modal" >
                                    </div>
                                    <div class="product-overlay">
                                        <a class="compare fa fa-signal fs-compare-add" fs-productID="${product.productID}"></a>
                                        <a class="likeitem fa fa-heart-o fs-wishlish-add" 
                                           fs-userID="${sessionScope.findUsersID}" 
                                           fs-productID="${product.productID}"></a>
                                        <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                    </div>
                                </div>
                                <div class="product-info">
                                    <h4 class="product-title">
                                        <a href="${product.productID}-${product.productColorListWorking[0].colorID}-${product.productNameNA}.html">
                                            ${product.productName}
                                        </a>
                                    </h4>
                                    <span class="product-price">
                                        <c:if test="${product.productDiscount > 0}">
                                            <small class="cutprice">$ ${product.price}0 </small>  $
                                            <fmt:formatNumber type="number" maxFractionDigits="2" value="${product.price - (product.price*product.productDiscount/100)}" var="prodPrice"/>
                                            ${fn:replace(prodPrice, ",", ".")}
                                        </c:if>
                                        <c:if test="${product.productDiscount == 0}">
                                            $ ${product.price}0
                                        </c:if>
                                    </span>
                                    <div class="item-colors" style="height: 25px;">
                                        <c:if test="${product.productColorListWorking.size() > 1}">
                                            <c:forEach items="${product.productColorListWorking}" var="color" begin="0" end="4">
                                                <img src="assets/images/products/colors/${color.urlColorImg}" 
                                                     class="img-responsive fs-index-color-img" 
                                                     fs-index-color-img="${color.colorID}" 
                                                     fs-product="${product.productID}" 
                                                     alt="${color.urlColorImg}" 
                                                     title="${color.color}"/>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>                
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- POLICY -->
<div class="policy-item parallax-bg1">
    <div class="container">
        <div class="row">
            <div class="col-md-3 col-sm-3">
                <div class="pi-wrap text-center">
                    <i class="fa fa-plane"></i>
                    <h4>Free shipping<span>Free shipping on all UK order</span></h4>
                    <p>Nulla ac nisi egestas metus aliquet euismod. Sed pulvinar lorem at pretium.</p>
                </div>
            </div>
            <div class="col-md-3 col-sm-3">
                <div class="pi-wrap text-center">
                    <i class="fa fa-money"></i>
                    <h4>Money Guarantee<span>30 days money back guarantee !</span></h4>
                    <p>Curabitur ornare urna enim, et lacinia purus tristique eulla eget feugiat diam.</p>
                </div>
            </div>
            <div class="col-md-3 col-sm-3">
                <div class="pi-wrap text-center">
                    <i class="fa fa-clock-o"></i>
                    <h4>Store Hours<span>Open: 9:00AM - Close: 21:00PM</span></h4>
                    <p>Etiam egestas purus eget sagittis lacinia. Morbi vel elit nec eros iaculis.</p>
                </div>
            </div>
            <div class="col-md-3 col-sm-3">
                <div class="pi-wrap text-center">
                    <i class="fa fa-life-ring"></i>
                    <h4>Support 24/7<span>We support online 24 hours a day</span></h4>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit integer congue.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- BLOG -->
<div class="home-blog">
    <div class="container">
        <h5 class="heading space40"><span>Latest from our blog</span></h5>
        <div class="row match-my-cols">
            <c:forEach items="${blogListIndex}" var="blog" begin="0" end="2" varStatus="no">
                <div class="col-md-4 col-sm-4">
                    <article class="home-post text-center equal-height">
                        <div class="post-thumb">
                            <a href="./blog-detail/${blog.blogID}.html">
                                <img src="assets/images/blog/${blog.blogImg}" class="img-responsive" alt=""/>
                                <div class="overlay-rmore fa fa-link"></div>
                            </a>
                        </div>
                        <div class="post-excerpt">
                            <h4><a href="./blog-detail/${blog.blogID}.html">${blog.blogTitle}</a></h4>
                            <div class="hp-meta">
<!--                                <span><i class="fa fa-edit"></i>${blog.postedDate}</span>  -->
                                <span><fmt:formatDate pattern="MM/dd/yyyy" value="${blog.postedDate}"/></span>
                            </div>
                            <p>${blog.blogSummary}</p>
                        </div>
                    </article>   
                </div>
            </c:forEach>
        </div>
    </div>
    <script>
        $(function () {
            $('.equal-height').matchHeight();
            $('.product-item').matchHeight();
        });
    </script>

    <!-- LATEST PRODUCTS -->
    <div class="container padding40">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <h5 class="heading space40"><span>Latest Products</span></h5>
                <div class="product-carousel3">
                    <c:forEach items="${latestProducts}" var="ltp" begin="0" end="7">
                        <div class="pc-wrap">
                            <div class="product-item">
                                <div class="item-thumb">
                                    <c:if test="${ltp.productDiscount > 0}">
                                        <div class="badge offer">-${ltp.productDiscount}%</div>
                                    </c:if>
                                    <img src="assets/images/products/${ltp.urlImg}" 
                                         class="img-responsive" 
                                         alt="${ltp.urlImg}" 
                                         fs-product-for-img="${ltp.productID}"/>
                                    <div class="overlay-rmore fa fa-search quickview fs-product-modal" 
                                         fs-product="${ltp.productID}" 
                                         fs-product-modal-color="${ltp.productColorListWorking[0].colorID}" 
                                         data-toggle="modal" ></div>
                                    <div class="product-overlay">
                                        <a class="compare fa fa-signal fs-compare-add" fs-productID="${ltp.productID}"></a>
                                        <a class="likeitem fa fa-heart-o fs-wl-add-lsp"
                                           fs-userID="${sessionScope.findUsersID}" fs-productID="${ltp.productID}" ></a>
                                        <input type="hidden" name="emailUser" value="${sessionScope.emailUser}" />
                                    </div>
                                </div>
                                <div class="product-info">
                                    <h4 class="product-title">
                                        <a href="${ltp.productID}-${ltp.productColorListWorking[0].colorID}-${ltp.productNameNA}.html">
                                            ${ltp.productName}
                                        </a>
                                    </h4>

                                    <span class="product-price">
                                        <c:if test="${ltp.productDiscount > 0}">
                                            <small class="cutprice">$ ${ltp.price}0 </small>  $
                                            <fmt:formatNumber type="number" maxFractionDigits="2" value="${ltp.price - (ltp.price*ltp.productDiscount/100)}" var="ltpPrice"/>
                                            ${fn:replace(ltpPrice, ",", ".")}

                                        </c:if>
                                        <c:if test="${ltp.productDiscount == 0}">
                                            $ ${ltp.price}0
                                        </c:if>
                                    </span>

                                    <div class="item-colors">
                                        <c:if test="${ltp.productColorListWorking.size() > 1}">
                                            <c:forEach items="${ltp.productColorListWorking}" var="color">
                                                <img src="assets/images/products/colors/${color.urlColorImg}" 
                                                     class="img-responsive fs-index-color-img" 
                                                     fs-index-color-img="${color.colorID}" 
                                                     fs-product="${ltp.productID}" 
                                                     alt="${color.urlColorImg}" 
                                                     title="${color.color}"/>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <div class="space10 clearfix"></div>

    <!-- CLIENTS -->
    <div class="clients">
        <div class="container">
            <div class="row">
                <div class="col-md-12 col-sm-12"> 
                </div>
            </div>
        </div>
    </div>

    <!-- FOOTER WIDGETS -->
    <div class="f-widgets">
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-sm-4">
                    <h6>Best Seller</h6>
                    <div class="f-widget-content">
                        <ul>
                            <c:forEach items="${bestSellerList}" var="prod">
                                <li>
                                    <div class="fw-thumb">
                                        <img src="assets/images/products/${prod[4]}" alt="${prod[4]}"/>
                                    </div>
                                    <div class="fw-info">
                                        <h4>
                                            <a href="${prod[0]}-${prod[5]}-${prod[2]}.html">
                                                ${prod[1]}
                                            </a>
                                        </h4>
                                        <span class="fw-price">$ ${prod[3]}0</span>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4">
                    <h6>Most Viewed</h6>
                    <div class="f-widget-content">
                        <ul>
                            <c:forEach items="${mostViewList}" var="prod">
                                <li>
                                    <div class="fw-thumb">
                                        <img src="assets/images/products/${prod.urlImg}" alt="${prod.urlImg}"/>
                                    </div>
                                    <div class="fw-info">
                                        <h4>
                                            <a href="${prod.productID}-${prod.productColorListWorking[0].colorID}-${prod.productNameNA}.html">
                                                ${prod.productName}
                                            </a>
                                        </h4>
                                        <span class="fw-price">$ ${prod.price}0</span>
                                    </div>
                                </li>
                            </c:forEach>

                        </ul>
                    </div>
                </div>
                <div class="col-md-4 col-sm-4">
                    <h6>Top Rated</h6>
                    <div class="f-widget-content">
                        <ul id="fs-recent-product-index-page">
                            <c:forEach items="${productTopRateList}" var="prod" varStatus="ind">
                                <li>
                                    <div class="fw-thumb">
                                        <img src="assets/images/products/${prod[0].urlImg}" alt="${prod[0].urlImg}"/>
                                    </div>
                                    <div class="fw-info">
                                        <h4>
                                            <a href="${prod[0].productID}-${prod[0].productColorListWorking[0].colorID}-${prod[0].productNameNA}.html">
                                                ${prod[0].productName}
                                            </a>
                                        </h4>
                                        <select id="fs-index-top-rating-result-${ind.index}" data-current-rating="${prod[1]}">
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                        </select>
                                        <span class="fw-price">$ ${prod[0].price}0</span>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- IMPORT MODAL -->
    <jsp:include page="../blocks/modal.jsp" flush="true"/>
    
    <div class="ajax-progress"></div>
</div>