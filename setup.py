#!/usr/bin/env python

"""The setup script."""

from setuptools import setup, find_packages

with open("README.rst") as readme_file:
    readme = readme_file.read()

with open("USAGE.rst") as usage_file:
    usage = usage_file.read()

requirements = [
    "pytest-kind==22.9.0",
    "kubernetes",
    "boto3",
    "awscli",
    "ansible-core==2.13.4",
]

test_requirements = [
    "pytest==7.1.3",
    "tox==3.26.0",
    "pick==2.0.2",
    "bandit==1.7.4",
    "black==22.8.0",
    "flake8==5.0.4",
    "bump2version==1.0.1",
]

extras = {
    "tests": test_requirements,
    "test": test_requirements,
    "develop": [
        "Sphinx==5.1.1",
    ]
    + test_requirements,
}

setup(
    author="kubify",
    author_email="w@kubify.com",
    python_requires=">=3.7",
    classifiers=[
        "Development Status :: 2 - Pre-Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: BSD License",
        "Natural Language :: English",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
    ],
    description="Automated EKS",
    entry_points={
        "console_scripts": [
            "kubify=kubify.cli:main",
        ],
    },
    install_requires=requirements,
    license="BSD license",
    long_description=readme + "\n\n" + usage,
    include_package_data=True,
    keywords="kubify",
    name="kubify",
    packages=find_packages(include=["kubify", "kubify.*"]),
    test_suite="tests",
    tests_requires=test_requirements,
    extras_require=extras,
    url="https://github.com/willyguggenheim/kubify",
    version="9010.0.2",
    zip_safe=False,
)