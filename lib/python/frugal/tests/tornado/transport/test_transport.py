# Copyright 2017 Workiva
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from tornado.testing import gen_test, AsyncTestCase

from frugal.tornado.transport import FTransportBase


class TestFTornadoTransport(AsyncTestCase):

    def setUp(self):
        self.transport = FTransportBase()

        super(TestFTornadoTransport, self).setUp()

    def test_is_open_raises_not_implemented_error(self):
        with self.assertRaises(NotImplementedError) as cm:
            self.transport.is_open()

        self.assertEquals("You must override this.", cm.exception.message)

    @gen_test
    def test_open_raises_not_implemented_error(self):
        with self.assertRaises(NotImplementedError) as cm:
            yield self.transport.open()

        self.assertEquals("You must override this.", cm.exception.message)

    @gen_test
    def test_close_raises_not_implemented_error(self):
        with self.assertRaises(NotImplementedError) as cm:
            yield self.transport.close()

        self.assertEquals("You must override this.", cm.exception.message)

    @gen_test
    def test_oneway_raises_not_implemented_error(self):
        with self.assertRaises(NotImplementedError) as cm:
            yield self.transport.oneway(None, [])

        self.assertEquals("You must override this.", cm.exception.message)

    @gen_test
    def test_request_raises_not_implemented_error(self):
        with self.assertRaises(NotImplementedError) as cm:
            yield self.transport.request(None, [])

        self.assertEquals("You must override this.", cm.exception.message)

