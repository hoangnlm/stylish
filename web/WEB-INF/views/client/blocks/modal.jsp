<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!--Modal thong bao dang nhap-->
<div id="fs-modal-mess" class="modal fade fs-modal-wl-mess" tabindex="-1" role="dialog" aria-labelledby="messlodalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
    <div class="modal-content fs-modal-wl-content">
        <p class="text-center fs-wl-text"><b>If you want add a product to your wishlish, <br/><br/>you should login to your account!!</b></p>
        <div class="modal-header">
            <a class="close fs-modal-wl-close" data-dismiss="modal" aria-label="Close">x</a>
        </div>
    </div>
</div>

<!--MODAL THONG BAO CHO KHI CO MODAL-->
<div id="fs-wl-ajax-error" class="modal fade fs-modal-mess-wl" tabindex="-1" role="dialog">
    <div class="modal-content fs-modal-wl-content">
        <!--<h1 id="fs-mess-wl" style="color: #31b131; text-align: center">SUCCESS</h1>-->
        <h1 id="fs-mess-wl-success" style="color: #31b131; text-align: center"></h1>
        <h1 id="fs-mess-wl-error" style="color: #F65D20; text-align: center"></h1>

        <div class="modal-header">
            <button class="close" data-dismiss="modal">&times;</button>
            <!--<h1 id="fs-mess-wl" style="color: #31b131; text-align: center"></h1>-->
        </div>
        <div class="modal-body">
            <!--<p id="fs-mess-body-wl">Add Wish List success.</p>-->
            <p id="fs-mess-body-wl"></p>
        </div>
    </div>
</div>

<!--PRODUCT DETAILS MODAL-->
<div class="modal fade" id="productModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-ku">
        <div class="modal-content">
            <button type="button" class="close fs-modal-close" data-dismiss="modal" aria-hidden="true">
                <i class="fa fa-times"></i>
            </button>
            <div class="row">
                <div class="col-md-5 col-sm-6" id="fs-product-modal-slide-img">
                    <div class="owl-carousel sync1 fs-main-product-img">

                    </div>

                    <div class="owl-carousel sync2 fs-main-product-img">

                    </div>
                </div>
                <div class="col-md-7 col-sm-6">
                    <div class="product-single fs-modal-product">
                        <div id="error-cart-product-modal">
                        </div>
                        <div class="ps-header">
                            <h3 class="fs-product-name"></h3>
                            <div class="ps-price fs-product-price"></div>
                        </div>

                        <div class="ps-stock">
                            Available: <span style="color: #FF6699" class="fs-quantity-in-stock">---</span>
                            <div class="fs-display-none" id="fs-show-quantity"></div>
                        </div>

                        <div class="sep"></div>
                        <div class="ps-color fs-product-modal-color">
                            <p>Color<span>*</span></p>                         
                            <div class="fs-product-modal-color-border">

                            </div>
                        </div>
                        <div class="fs-clear-fix"></div>
                        <div class="space10"></div>
                        <div class="row select-wraps">
                            <div class="col-md-7 col-xs-7">
                                <p>Size<span>*</span></p>
                                <div id="fs-product-modal-size">

                                </div>
                            </div>

                            <div class="col-md-4 col-xs-5 col-lg-4">
                                <p style="margin-bottom: 8px !important;">Quantity<span>*</span></p>
                                <div class="input-group">
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-danger fs-modal-btn-number fs-modal-btn-quantity-minus" data-type="minus" disabled>
                                            <span class="glyphicon glyphicon-minus"></span>
                                        </button>
                                    </span>

                                    <input style="padding: 12px;" type="text" name="" class="form-control fs-modal-input-number text-center" value="1" min="1" max="10" disabled>

                                    <span class="input-group-btn">
                                        <button type="button" disabled class="btn btn-success fs-modal-btn-number fs-modal-btn-quantity-plus" data-type="plus">
                                            <span class="glyphicon glyphicon-plus"></span>
                                        </button>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="space20"></div>
                        <div class="space20"></div>
                        <div class="sep"></div>
                        <!--<form method="POST" action="">-->
                        <!--<a class="fs-modal-btn-addtobag" href="#">Add to Cart</a>-->
                        <button class="fs-modal-btn-addtobag">Add to Cart</button>
                        <!--</form>-->
                        <a class="fs-product-modal-link-to-detail" href="#">Go to Details</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>