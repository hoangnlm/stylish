<!-- BREADCRUMBS -->
<!--COMPARE PRODUCTS-->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div id="loginModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-dialog">
        <div class="modal-content login-modal">
            <div class="modal-header login-modal-header">
                <button type="button" class="close" style="color: black" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title text-center"><i class="fa fa-signal" style="font-size: 20px;"></i> COMPARE PRODUCTS</h4>
            </div>
            <div class="modal-body">
                <div class="container">
                    <section class="cd-products-comparison-table">
                        <header>
                            <h2>Compare Models</h2>

                            <div class="actions">
                                <a href="#0" class="reset">Reset</a>
                                <a href="#0" class="filter">Filter</a>
                            </div>
                        </header>

                        <div class="cd-products-table">
                            <div class="features">
                                <div class="top-info">Models</div>
                                <ul class="cd-features-list">
                                    <li>Price</li>
                                    <li>Customer Rating</li>
                                    <li>Resolution</li>
                                    <!-- other features here -->
                                </ul>
                            </div> <!-- .features -->

                            <div class="cd-products-wrapper">
                                <ul class="cd-products-columns">
                                    <li class="product">
                                        <div class="top-info">
                                            <div class="check"></div>
                                            <img src="../img/product.png" alt="product image">
                                            <h3>Sumsung Series 6 J6300</h3>
                                        </div> <!-- .top-info -->

                                        <ul class="cd-features-list">
                                            <li>$600</li>
                                            <li class="rate"><span>5/5</span></li>
                                            <li>1080p</li>
                                            <!-- other values here -->
                                        </ul>
                                    </li> <!-- .product -->

                                    <li class="product">
                                        <!-- product content here -->
                                    </li> <!-- .product -->

                                    <!-- other products here -->
                                </ul> <!-- .cd-products-columns -->
                            </div> <!-- .cd-products-wrapper -->

                            <ul class="cd-table-navigation">
                                <li><a href="#0" class="prev inactive">Prev</a></li>
                                <li><a href="#0" class="next">Next</a></li>
                            </ul>
                        </div> <!-- .cd-products-table -->
                    </section> <!-- .cd-products-comparison-table -->
                </div>
            </div>
        </div>
    </div>
</div>



