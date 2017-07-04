<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!-- BREADCRUMBS -->
<jsp:include page="../blocks/breadcrumbs.jsp" flush="true" />

<!-- MY ACCOUNT -->
<div class="account-wrap">
    <div class="container">
        <div class="row">
            <div class="col-sm-8 col-md-9">
                <!-- HTML -->
                <div id="account-id">
                    <h4 class="account-title"><span class="fa fa-chevron-right"></span>Change Your Address</h4>                                                                  
                    <div class="account-form">
                        <form:form id="address-update" cssClass="fs-form-update-address" action="user/address-book/${sessionScope.findUsersID}-${addressID}.html" method="post" modelAttribute="userAddresses">                                        
                            ${error}
                            <ul class="form-list row">
                                <li class="col-md-6 col-sm-6">
                                    <div class="form-group has-feedback">
                                        <label>Address <em>*</em></label>
                                        <form:input path="address" id="txt-address" cssClass="input-text fs-update-address form-control addressVal"/>
                                    </div>
                                </li>

                                <li class="col-md-6 col-sm-6">
                                    <div class="form-group has-feedback">
                                        <label><i class="fa fa-phone"></i> Phone Number <em>*</em></label>
                                        <form:input path="phoneNumber" id="txt-phone" cssClass="input-text fs-update-phone form-control phoneVal"/>
                                    </div>
                                </li>
                            </ul>
                            <div class="form-group center-block">
                                <button class="btn-black" type="submit">Update</button>
                                <a href="user/address-list/${sessionScope.findUsersID}.html"><button class="btn-black" type="button">Back</button></a>
                            </div>
                        </form:form>
                    </div>                                    
                </div>
            </div>
            <script>
                function test(e){
                    console.log(e);
                    return false;
                }
            </script>

            <div class="col-sm-4 col-md-3  checkout-steps">
                <!-- USER-RIGHT-MENU -->
                <jsp:include page="../blocks/user-right-menu.jsp" flush="true" />
            </div>
        </div>
    </div>
</div>
<div class="clearfix space20"></div>
