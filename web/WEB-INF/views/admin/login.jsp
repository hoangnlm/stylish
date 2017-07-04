<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <base href="${pageContext.servletContext.contextPath}/" />
        <title>SB Admin 2 - Bootstrap Admin Theme</title>

        <!-- Bootstrap Core CSS -->
        <link href="assets/admin/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="assets/admin/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="assets/admin/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="assets/admin/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->
        <!-- jQuery -->
        <script src="assets/admin/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="assets/admin/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="assets/admin/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="assets/admin/dist/js/sb-admin-2.js"></script>

        <script src="assets/js/jquery.validate.min.js"></script>
    </head>

    <body>
        <div class="container">
            <div class="row">
                <div class="col-md-4 col-md-offset-4">
                    <div class="login-panel panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">Please Sign In</h3>
                        </div>
                        ${error} <!-- Ti sua mot thong bao loi hien thi cho dep --> 
                        <div class="panel-body">
                            <form method="POST" id="fs-form-login-admin" action="admin/login.html" autocomplete="off">
                                <div class="form-group fa-vali-email-admin has-feedback">
                                    <input class="form-control emailVal" id="fs-email-login-admin" placeholder="E-mail" name="email" type="email" autofocus>
                                </div>
                                <div class="form-group fa-vali-pass-admin has-feedback">
                                    <input class="form-control passwordVal" id="fs-pass-login-admin" placeholder="Password" name="password" type="password" value="">
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input name="remember" type="checkbox" value="1">Remember Me
                                    </label>
                                </div>
                                <button style="background-color: #ff6699; border-color: #ff6699;" class="btn btn-lg btn-success btn-block fs-button-login-admin">Login</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $(function () {
                $.validator.addClassRules({
                    emailVal: {
                        required: true,
                        email: true
                    },
                    passwordVal: {
                        required: true,
                        minlength: 6,
                        maxlength: 20
                    }
                });

                $("#fs-form-login-admin").validate({
                    errorElement: "em",
                    errorClass: "help-block",
                    errorPlacement: function (error, element) { // error: jQuery object, element: DOM object
                        // If element is a checkbox, insert after label
                        if (element.prop("type") === "checkbox") {
                            error.insertAfter(element.parent("label"));
                        } else {
                            error.insertAfter(element);
                        }
                        // Insert bootstrap feedback icon in the input
                        $("<span class='glyphicon glyphicon-remove form-control-feedback'></span>").insertAfter(element);
                    },
                    success: function (label, element) {    // valid
                        highlightValid($(element));
                    },
                    highlight: function (element) {     // invalid
                        highlightInvalid($(element));
                    }
                });
            })

            function highlightValid(element) { // element: jquery object
                element.parents(".has-feedback").addClass("has-success").removeClass("has-error");
                element.next("span").addClass("glyphicon-ok").removeClass("glyphicon-remove");
            }

            function highlightInvalid(element) { // element: jquery object
                element.parents(".has-feedback").addClass("has-error").removeClass("has-success");
                element.next("span").addClass("glyphicon-remove").removeClass("glyphicon-ok");
            }

        </script>
    </body>

</html>
