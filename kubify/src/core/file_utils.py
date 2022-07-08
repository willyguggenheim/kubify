import os


def delete_file_list(fileList):
    # Iterate over the list of filepaths & remove each file.
    for filePath in fileList:
        try:
            os.remove(filePath)
        except OSError:
            print("Error while deleting file")


def copy_file(src, dst):
    with open(src, "r") as firstfile, open(dst, "a+") as secondfile:
        for line in firstfile:
            secondfile.write(line)
