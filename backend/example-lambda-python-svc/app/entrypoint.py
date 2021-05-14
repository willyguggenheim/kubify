import boto3

def entrypoint(input):
	print('Hello Kubify Lambda: %s' % input)
	sleep(10)

if __name__ == "__main__":
    entrypoint("test")
