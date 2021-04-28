from kubify import *

from unittest.mock import patch

def test_check_arg():
    with \
        patch('KUBIFY.print') as mock_print, \
        patch('sys.exit') as mock_sys_exit:
        
        check_arg(None, "error")
        
        assert mock_print.called == True
        assert mock_print.call_count == 1
        assert mock_sys_exit.called == True
        assert mock_sys_exit.call_count == 1

        assert mock_print.call_args_list[0][0][0] == 'error'
        assert mock_sys_exit.call_args_list[0][0][0] == 1

    with \
        patch('KUBIFY.print') as mock_print, \
        patch('sys.exit') as mock_sys_exit:

        check_arg([], "error")
        
        assert mock_print.called == True
        assert mock_print.call_count == 1
        assert mock_sys_exit.called == True
        assert mock_sys_exit.call_count == 1

        assert mock_print.call_args_list[0][0][0] == 'error'
        assert mock_sys_exit.call_args_list[0][0][0] == 1


    with \
        patch('KUBIFY.print') as mock_print, \
        patch('sys.exit') as mock_sys_exit:

        check_arg("", "error")
        
        assert mock_print.called == True
        assert mock_print.call_count == 1
        assert mock_sys_exit.called == True
        assert mock_sys_exit.call_count == 1

        assert mock_print.call_args_list[0][0][0] == 'error'
        assert mock_sys_exit.call_args_list[0][0][0] == 1
