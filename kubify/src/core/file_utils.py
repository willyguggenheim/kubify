import os


def delete_file_list(file_list):
    # Iterate over the list of filepaths & remove each file.
    for file_path in file_list:
        try:
            os.remove(file_path)
        except OSError:
            print("Error while deleting file")


def copy_file(src, dst):
    with open(src, "r") as firstfile, open(dst, "a+") as secondfile:
        for line in firstfile:
            secondfile.write(line)
