/*
 * Copyright 2018 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Firestore/core/src/firebase/firestore/remote/grpc_queue.h"

#include "Firestore/core/src/firebase/firestore/util/hard_assert.h"

namespace firebase {
namespace firestore {
namespace remote {

GrpcCompletionQueue::~GrpcCompletionQueue() {
  if (!is_shut_down_) {
    Shutdown();
  }
}

void GrpcCompletionQueue::Shutdown() {
  HARD_ASSERT(!is_shut_down_, "GRPC queue shut down twice");
  is_shut_down_ = true;
  queue_.Shutdown();
}

GrpcOperation* GrpcCompletionQueue::Next(bool* ok) {
  void* tag = nullptr;
  bool has_more = queue_.Next(&tag, ok);
  if (!has_more) {
    return nullptr;
  }
  // In Firestore, the tag is always a dynamically-allocated `GrpcOperation`.
  return static_cast<GrpcOperation*>(tag);
}

}  // namespace remote
}  // namespace firestore
}  // namespace firebase
