import kubify.src.aws.s3_utils as module_0


def test_case_0():
    try:
        bytes_0 = b"\xa8\xaeK"
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.put_bucket_encryption(bytes_0)
    except BaseException:
        pass


def test_case_1():
    try:
        int_0 = 935
        set_0 = {int_0, int_0}
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.put_bucket_encryption(set_0)
    except BaseException:
        pass


def test_case_2():
    try:
        s3_utils_0 = module_0.S3Utils()
        str_0 = "5"
        var_0 = s3_utils_0.get_bucket(str_0)
        assert var_0 is None
        set_0 = {var_0, str_0, s3_utils_0, s3_utils_0}
        s3_utils_0.get_bucket(set_0)
    except BaseException:
        pass


def test_case_3():
    try:
        str_0 = "kNhzCQPi{;Vsw-kOD\r1n"
        set_0 = {str_0, str_0}
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.put_bucket_encryption(set_0)
    except BaseException:
        pass


def test_case_4():
    try:
        str_0 = "6w2I,>6C*+!,xD'0"
        s3_utils_0 = module_0.S3Utils()
        s3_utils_0.create_bucket(str_0, str_0)
    except BaseException:
        pass


def test_case_5():
    try:
        bytes_0 = b'\x02"\xc4_\xd2\xb6\xa6Q|'
        bool_0 = False
        str_0 = "_"
        s3_utils_0 = module_0.S3Utils()
        var_0 = s3_utils_0.get_bucket(str_0)
        assert var_0 is None
        s3_utils_1 = module_0.S3Utils()
        s3_utils_1.create_bucket(bytes_0, bool_0)
    except BaseException:
        pass


# def test_case_6():
#     try:
#         except BaseException:
#             pass
