/*
 * Copyright 2020 Huawei Technologies Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.eliot.eliotbe.eliotk8sclient.deploy;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.util.List;

public abstract class GenericDeploy {

    protected void search(final String pattern, final File folder, List<String> result) {
        File[] files = folder.listFiles();
        if (null != files) {
            for (final File f : files) {
                if (f.isDirectory()) {
                    search(pattern, f, result);
                }
                handleFile(f, pattern, result);
            }
        }
    }

    private void handleFile(File f, String pattern, List<String> result) {
        if (f.isFile() && f.getName().matches(pattern)) {
            try {
                result.add(f.getCanonicalPath());
            } catch (IOException e) {
                return;
            }
        }
    }

    public abstract String deploy(String packagepath);
}
