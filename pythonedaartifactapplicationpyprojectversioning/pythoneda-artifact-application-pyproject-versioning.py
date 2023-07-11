#!/usr/bin/env python3
"""
pythonedaartifactapplicationpyprojectversioning/pythoneda-artifact-application-pyproject-versioning.py

This file defines PyprojectVersioning.

Copyright (C) 2023-today rydnr's pythoneda-artifact-application/pyproject-versioning

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""
import asyncio
from pythonedaapplication.pythoneda import PythonEDA

class PyprojectVersioning(PythonEDA):
    """
    PythonEDA application that runs Pyproject Versioning artifact space.

    Class name: PyprojectVersioning

    Responsibilities:
        - Runs Pyproject Versioning artifact space.

    Collaborators:
        - asyncio: To manage asynchronous threads.
    """
    def __init__(self):
        """
        Creates a new PyprojectVersioning instance.
        """
        super().__init__(__file__)

if __name__ == "__main__":

    asyncio.run(PyprojectVersioning.main())
