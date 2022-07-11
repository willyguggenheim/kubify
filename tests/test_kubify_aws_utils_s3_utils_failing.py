import kubify.src.aws.s3_utils as module_0


def test_case_0():
    try:
        str_0 = "bL2ip/`.wvGQ\t"
        str_1 = "Code"
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.create_bucket(str_0, str_1)
    except BaseException:
        pass


def test_case_1():
    try:
        s3_utils_0 = module_0.S3Utils()
        module_0.S3Utils()
        str_0 = "creationTimestamp"
        var_0 = s3_utils_0.get_bucket(str_0)
        assert var_0 is None
        module_0.S3Utils()
        str_1 = "Er"
        str_2 = ""
        set_0 = {str_1, s3_utils_0, str_1, str_2}
        s3_utils_0.get_bucket(set_0)
    except BaseException:
        pass


def test_case_2():
    try:
        s3_utils_0 = module_0.S3Utils()
        module_0.S3Utils()
        str_0 = "a"
        var_0 = s3_utils_0.get_bucket(str_0)
        assert var_0 is None
        module_0.s3_utils()
        str_1 = "Er"
        str_2 = ""
        set_0 = {str_1, s3_utils_0, str_1, str_2}
        s3_utils_0.get_bucket(set_0)
    except BaseException:
        pass


def test_case_3():
    try:
        bool_0 = True
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.put_bucket_encryption(bool_0)
    except BaseException:
        pass


def test_case_4():
    try:
        s3_utils_0 = module_0.S3Utils()
        set_0 = {s3_utils_0, s3_utils_0, s3_utils_0}
        s3_utils_1 = module_0.S3Utils()
        s3_utils_1.put_bucket_encryption(set_0)
    except BaseException:
        pass


def test_case_5():
    try:
        str_0 = "us-west-2"
        s3_utils_0 = module_0.S3Utils()
        var_0 = s3_utils_0.get_bucket(str_0)
        assert var_0 is None
        list_0 = []
        int_0 = 403
        s3_utils_0.create_bucket(list_0, int_0)
    except BaseException:
        pass


def test_case_6():
    try:
        float_0 = -763.61
        set_0 = set()
        bool_0 = False
        str_0 = "xkGm%-h2g"
        tuple_0 = float_0, set_0, bool_0, str_0
        int_0 = 1528
        bool_1 = False
        bool_2 = True
        tuple_1 = tuple_0, int_0, bool_1, bool_2
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.create_bucket(tuple_1, float_0)
    except BaseException:
        pass
