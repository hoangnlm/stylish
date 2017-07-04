<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<!DOCTYPE html>
<!--[if IE 8]>			<html class="ie ie8"> <![endif]-->
<!--[if IE 9]>			<html class="ie ie9"> <![endif]-->
<!--[if gt IE 9]><!-->	<html> <!--<![endif]-->
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
        <meta name="author" content="HoangNLM"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <base href="${pageContext.servletContext.contextPath}/"/>
        <title>Admin | Stylish Store</title>
        <link rel="shortcut icon" href="assets/images/favicon.ico"/>

        <!-- Bootstrap Core CSS -->
        <link href="assets/admin/vendor/bootstrap/css/bootstrap.css" rel="stylesheet">

        <!-- Bootstrap Toggle CSS -->
        <link href="assets/admin/vendor/bootstrap-toggle/bootstrap-toggle.min.css" rel="stylesheet">

        <!-- For morris.js chart -->
        <link rel="stylesheet" href="assets/admin/vendor/morrisjs/morris.css">

        <!-- MetisMenu CSS -->
        <link href="assets/admin/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- DataTables CSS -->
        <link href="assets/admin/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">

        <!-- DataTables Responsive CSS -->
        <link href="assets/admin/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="assets/admin/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- JQUERY UI CSS -->
        <link href="assets/js/jquery-ui-1.12.1/jquery-ui.min.css" rel="stylesheet" type="text/css"/>

        <!-- Custom Fonts -->
        <link href="assets/admin/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- fileUploader -->
        <link href="assets/admin/dist/css/jquery.fileuploader.css" rel="stylesheet" type="text/css"/>

        <!-- animate - use with bootstrap notify -->
        <link href="assets/css/animate.css" rel="stylesheet" type="text/css"/>
        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

        <!--Thông báo css cập nhật thành công-->
        <link href="assets/css/sweetalert.css" rel="stylesheet" type="text/css"/>

        <!--Bootstrap X-EditAble-->
        <link href="assets/admin/dist/css/bootstrap-editable.css" rel="stylesheet" type="text/css"/>

        <!-- Custom Stylish Store CSS -->
        <link href="assets/admin/dist/css/stylish_settings.css" rel="stylesheet" type="text/css"/>


        <!--JAVASCRIPT-->
        <script src="assets/ckeditor/ckeditor.js" type="text/javascript"></script>
        <script src="assets/ckfinder/ckfinder.js" type="text/javascript"></script>

        <!-- jQuery -->
        <script src="assets/admin/vendor/jquery/jquery.min.js"></script>
        <script src="assets/js/jquery.validate.min.js"></script>
        <script src="assets/js/jquery.form.min.js"></script>
        <script src="assets/js/jquery-ui-1.12.1/jquery-ui.min.js" type="text/javascript"></script>
        <script src="assets/js/moment.min.js"></script>

        <!-- For morris.js chart -->
        <script src="assets/admin/vendor/morrisjs/morris.min.js" type="text/javascript"></script>
        <script src="assets/admin/vendor/raphael/raphael.min.js" type="text/javascript"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="assets/admin/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="assets/admin/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- DataTables JavaScript -->
        <script src="assets/admin/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="assets/admin/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="assets/admin/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- fileUploader -->
        <script src="assets/admin/dist/js/jquery.fileuploader.min.js" type="text/javascript"></script>

        <!-- Custom Theme JavaScript -->
        <script src="assets/admin/dist/js/sb-admin-2.js"></script>

        <script src="assets/js/sweetalert.min.js"></script>

        <!--bootstrap notify-->
        <script src="assets/js/bootstrap-notify.js" type="text/javascript"></script>

        <!--bootstrap x-editable-->
        <script src="assets/admin/dist/js/bootstrap-editable.js" type="text/javascript"></script>

        <!--bootstrap toggle-->
        <script src="assets/admin/vendor/bootstrap-toggle/bootstrap-toggle.min.js" type="text/javascript"></script>

        <!--Flot Chart-->
        <script src="assets/admin/vendor/flot/jquery.flot.js"></script>
        <script src="assets/admin/vendor/flot/jquery.flot.pie.js"></script>
        <script src="assets/admin/vendor/flot/jquery.flot.resize.js"></script>
        <script src="assets/admin/vendor/flot/jquery.flot.time.js"></script>
        <script src="assets/admin/vendor/flot-tooltip/jquery.flot.tooltip.min.js"></script>
        <script src="assets/admin/vendor/flot/jquery.flot.axislabels.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script src="assets/admin/dist/js/stylish_settings.js" type="text/javascript"></script>

        <!-- CKEditor -->
        <script src="assets/js/ckeditor.js" type="text/javascript"></script>
    </head>

    <body id="admin">        
        <div id="wrapper">

            <!-- HEADER - MENU -->
            <tiles:insertAttribute name="header" />

            <!-- PAGE CONTENT -->
            <tiles:insertAttribute name="content" />

        </div>
        <!-- /#wrapper -->

    </body>

</html>
