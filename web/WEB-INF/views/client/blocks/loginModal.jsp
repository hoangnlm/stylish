<!-- BREADCRUMBS -->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<style>
    .ui-datepicker {
        height: auto !important;
        width: 19em;
    }
</style>

<!--LOGIN MODAL-->
<div id="loginModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="loginModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
    <div class="modal-dialog">
        <div class="modal-content login-modal">
            <div class="modal-header login-modal-header">
                <button type="button" class="close" style="color: black" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title text-center" id="loginModalLabel"><i class="fa fa-user" style="font-size: 20px;"></i> USER LOGIN</h4>
            </div>
            <div class="modal-body">
                <form name="fs-form-login-user" action="login.html" method="post" class="form-login fs-login-modal" id="fs-form-login-user" autocomplete="off"> 

                    <div class="form-group">
                        <p class="form-alert" id="login-error"></p>
                    </div>

                    <div class="form-group has-feedback">
                        <label for="login-email"><i class="fa fa-envelope"></i> Email <em class="asterisk">*</em></label>
                        <input type="email" class="form-control emailVal" id="login-email" name="email" autofocus="on"/>
                    </div>

                    <div class="form-group has-feedback">
                        <label for="login-password"><i class="fa fa-key"></i> Password <em class="asterisk">*</em></label>
                        <input type="password" class="form-control passwordVal" id="login-password" name="password"/>
                    </div>

                    <div class="form-group">
                        <div class="checkbox">
                            <label class="pull-left"><input type="checkbox" name="checkremember"> Remember me</label>
                            <em class="asterisk pull-right">* : Required input</em>
                        </div>
                    </div>

                    <div class="clearfix"></div>

                    <div class="form-group center-block">
                        <button class="btn-black fs-button-login-user" type="submit"><span>Login</span></button>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>


<!--REGISTER MODAL-->
<div id="registerModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="registerModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
    <div class="modal-dialog">
        <div class="modal-content login-modal">
            <div class="modal-header login-modal-header">
                <button type="button" class="close" style="color: black" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title text-center" id="registerModalLabel"><i class="fa fa-sign-in" style="font-size: 20px;"></i> USER REGISTER</h4>
            </div>
            <div class="modal-body">
                <form name="fs-form-create-user" class="form-login" method="post" action="user/register.html" id="fs-form-create-user" enctype="multipart/form-data" autocomplete="off">   

                    <div class="form-group">
                        <p class="form-alert" id="register-error"></p>
                    </div>

                    <ul class="form-list row">

                        <li class="col-md-12 col-sm-12">
                            <label><i class="fa fa-envelope"></i> Email <em>*</em></label>
                            <div class="fs-email-create has-feedback">
                                <input name="email" id="register-email" class="input-text form-control emailVal" type="email" autofocus=""/>
                            </div>
                        </li>

                        <li class="col-md-6 col-sm-12">
                            <label><i class="fa fa-key"></i> Password <em>*</em></label>
                            <div class="fs-password-create has-feedback">
                                <input type="password" id="register-password" name="password" class="input-text form-control passwordVal"  />
                            </div>
                        </li> 

                        <li class="col-md-6 col-sm-12">
                            <label><i class="fa fa-key"></i> Retype Password <em>*</em></label>
                            <div class="fs-repassword-create has-feedback">
                                <input type="password" id="register-password-re" name="repassword" class="input-text form-control repasswordVal" />
                            </div>
                        </li>

                        <li class="col-md-12 col-sm-6">
                            <label>First Name <em>*</em></label>
                            <div class="fs-firstname-create has-feedback">
                                <input name="firstName" id="register-firstname" class="input-text form-control firstNameVal" />
                            </div>
                        </li>

                        <li class="col-md-12 col-sm-6">
                            <label>Last Name <em>*</em></label>
                            <div class="fs-lastname-create has-feedback">
                                <input name="lastName" id="register-lastname" class="input-text form-control lastNameVal" />
                            </div>
                        </li>

                        <li class="col-md-6 col-sm-12">  
                            <label><i class="fa fa-venus-mars"></i> Gender</label>
                            <br>
                            <div class="text-center fs-login-gender">
                                <label>
                                    <input type="radio" name="gender"  value="1" checked="checked" /><i class="fa fa-male"></i> Male 
                                </label>
                                &nbsp;&nbsp;&nbsp;
                                <label>
                                    <input type="radio" name="gender" value="0" /><i class="fa fa-female"></i> Female 
                                </label>
                            </div>
                        </li>

                        <li class="col-md-6 col-sm-12">  
                            <label><i class="fa fa-birthday-cake"></i> Birthday <em>*</em></label>
                            <div class="fs-birthday-create has-feedback" >
                                <span id="fs-birthday-create"><input name="birthday" id="register-birthday" class="input-text form-control datepicker birthdayVal"/></span>
                            </div>
                        </li>

                        <li class="col-md-12 col-sm-12">
                            <label><i class="fa fa-phone"></i> Phone <em>*</em></label>
                            <div class="fs-phone-create has-feedback">
                                <input class="form-control phoneVal" type="text" id="fs-create-phone" name="phoneNumber"/>
                            </div>
                        </li>

                        <li class="col-md-12 col-sm-12">
                            <label>Address <em>*</em></label>
                            <div class="fs-address-create has-feedback">
                                <input class="form-control addressVal" type="text" id="fs-create-address" name="address" />
                            </div>
                        </li>

                    </ul>

                    <div class="form-group">
                        <em class="asterisk">* : Required input</em>
                    </div>

                    <div class="buttons-set text-center">
                        <button class="btn-black btn-custom fs-button-create-user" id="fs-button-create-user" type="submit"><span>Create Account</span></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


