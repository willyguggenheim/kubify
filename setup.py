#!/usr/bin/env python

"""The setup script."""

from setuptools import setup, find_packages

with open('README.md') as readme_file:
    readme = readme_file.read()

with open('HISTORY.rst') as history_file:
    history = history_file.read()

requirements = [ 'py-make', 'kubernetes', 'pick' ]

test_requirements = ['pytest>=3', ]

setup(
    author="kubify",
    author_email='w@kubify.com',
    python_requires='>=3.6',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
    ],
    description="Automated EKS",
    entry_points={
        'console_scripts': [
            'kubify=kubify.cli:main',
        ],
    },
    install_requires=requirements,
    license="BSD license",
    long_description=readme + '\n\n' + history,
    include_package_data=True,
    keywords='kubify',
    name='kubify',
    packages=find_packages(include=['kubify', 'kubify.*']),
    test_suite='tests',
    tests_require=test_requirements,
    url='https://github.com/willyguggenheim/kubify',
    version='9001.0.0',
    zip_safe=False,
)
