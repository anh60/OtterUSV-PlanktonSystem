# SPDX-FileCopyrightText: Copyright (c) 2022 Dan Halbert for Adafruit Industries
#
# SPDX-License-Identifier: MIT
"""
`circuitpython_typing`
================================================================================

Types needed for type annotation that are not in `typing`


* Author(s): Alec Delaney, Dan Halbert, Randy Hudson
"""

__version__ = "1.6.0"
__repo__ = "https://github.com/adafruit/Adafruit_CircuitPython_Typing.git"

import array
from typing import Union, Optional

# Protocol was introduced in Python 3.8.
try:
    from typing import Protocol  # pylint: disable=ungrouped-imports
except ImportError:
    from typing_extensions import Protocol

# Lists below are alphabetized.

# More added in each conditional import.
__all__ = [
    "Alarm",
    "AudioSample",
    "ByteStream",
    "FrameBuffer",
    "ReadableBuffer",
    "WriteableBuffer",
]

ReadableBuffer = Union[
    array.array,
    bytearray,
    bytes,
    memoryview,
    "rgbmatrix.RGBMatrix",
    "ulab.numpy.ndarray",
]
"""Classes that implement the readable buffer protocol."""

WriteableBuffer = Union[
    array.array,
    bytearray,
    memoryview,
    "rgbmatrix.RGBMatrix",
    "ulab.numpy.ndarray",
]
"""Classes that implement the writeable buffer protocol."""


class ByteStream(Protocol):
    """Protocol for basic I/O operations on a byte stream.
    Classes which implement this protocol include
    * `io.BytesIO`
    * `io.FileIO` (for a file open in binary mode)
    * `busio.UART`
    * `usb_cdc.Serial`
    """

    # Should be `, /)`, but not available in Python 3.7.
    def read(self, count: Optional[int] = None) -> Optional[bytes]:
        """Read ``count`` bytes from the stream.
        If ``count`` bytes are not immediately available,
        or if the parameter is not specified in the call,
        the outcome is implementation-dependent.
        """
        ...

    # Should be `, /)`, but not available in Python 3.7.
    def write(self, buf: ReadableBuffer) -> Optional[int]:
        """Write the bytes in ``buf`` to the stream."""
        ...


# These types may not be in adafruit-blinka, so use the string form instead of a resolved name.

AudioSample = Union[
    "audiocore.WaveFile",
    "audiocore.RawSample",
    "audiomixer.Mixer",
    "audiomp3.MP3Decoder",
    "synthio.MidiTrack",
]
"""Classes that implement the audiosample protocol.
You can play these back with `audioio.AudioOut`, `audiobusio.I2SOut` or `audiopwmio.PWMAudioOut`.
"""

FrameBuffer = Union["rgbmatrix.RGBMatrix"]
"""Classes that implement the framebuffer protocol."""

Alarm = Union["alarm.pin.PinAlarm", "alarm.time.TimeAlarm"]
"""Classes that implement alarms for sleeping and asynchronous notification.
You can use these alarms to wake up from light or deep sleep.
"""
