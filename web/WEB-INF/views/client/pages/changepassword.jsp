<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true"/>


<!-- MY ACCOUNT -->
<div class="account-wrap">
    <div class="container">
        <div class="row">
            <div class="col-md-9 col-sm-8">
                <!-- HTML -->
                <div id="account-id">
                    <h4 class="account-title"><span class="fa fa-chevron-right"></span>Change Your Password</h4>    
                    <div>

                    </div>
                    <div class="account-form">
                        ${error}
                        <div class="clearfix"></div>
                        <form id="shipping-zip-form" class="fs-form-change-pass" action="user/change-password/${sessionScope.findUsersID}.html" method="post" autocomplete="off">
                            <div class="form-group has-feedback">
                                <label><i class="fa fa-key"></i> Current Password<em class="asterisk">*</em></label>
                                <input required name="oldpassword" type="password" class="input-text fs-old-pass form-control passwordVal">
                            </div>

                            <div class="form-group">
                                <hr style="border: 4px double #ff6699;">
                            </div>

                            <div class="form-group has-feedback">
                                <label><i class="fa fa-key"></i> Password <em class="asterisk">*</em></label>
                                <input id="change-password" required name="password" type="password" class="input-text fs-password form-control passwordVal"><br/>
                            </div>

                            <div class="form-group has-feedback">
                                <label><i class="fa fa-key"></i> Password Confirm <em class="asterisk">*</em></label>
                                <input id="change-password-re" required name="repassword" type="password" class="input-text fs-repass form-control repasswordVal">
                            </div>

                            <div class="form-group center-block">
                                <button class="btn-black fs-button-change-pass" type="submit"><span><span>Update</span></span></button>
                            </div>

                        </form>
                    </div>                                 
                </div>
            </div>

            <div class="col-md-3 col-sm-4 checkout-steps">
                <!-- USER-RIGHT-MENU -->
                <jsp:include page="../blocks/user-right-menu.jsp" flush="true" />
            </div>
        </div>
    </div>
</div>
<div class="clearfix space20"></div>