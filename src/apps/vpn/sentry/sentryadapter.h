/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#ifndef SENTRYADAPTER_H
#define SENTRYADAPTER_H

#include <sentry.h>

#include <QApplication>
#include <QObject>

class SentryAdapter final : public QObject {
  Q_OBJECT
  Q_DISABLE_COPY_MOVE(SentryAdapter)

 public:
  ~SentryAdapter();
  static SentryAdapter* instance();

  /**
   * @brief Inits Sentry.
   *
   * This is a no-op if the client is in production mode.
   */
  void init();

  /**
   * @brief Sends an "Issue" report to Sentry
   *
   * @param category - "Category" of the error, any String is valid.
   * @param message - Additional message content.
   * @param attachStackTrace - If true a stacktrace for later debugging will be
   * attached.
   */
  void report(const QString& category, const QString& message,
              bool attachStackTrace = false);

  /**
   * @brief Event Slot for when a log-line is added.
   *
   * The logline will be added as a Sentry-Breadrumb, so that
   * the next "report" or crash will have the last few
   * loglines available
   *
   * @param line - UTF-8 encoded bytes of the logline.
   */
  Q_SLOT void onLoglineAdded(const QByteArray& line);

  /**
   * @brief Event Slot for when the client is about to Shut down
   *
   * This will call sentry to wrap up - this might cause new network requests
   * or drisk writes.
   * After calling this, any call to sentry is UB.
   */
  Q_SLOT void onBeforeShutdown();

  /**
   * @brief Callback for when sentry's backend recieved a crash.
   *
   * In this function we can decide to either send, discard the crash
   * and additonally "scrub" the minidump of data, if wanted.
   *
   * @param uctx provides the user-space context of the crash
   * @param event used the same way as in `before_send`
   * @param closure user-data that you can provide at configuration time
   * (we'dont.)
   * @return either the @param event or null_sentry_value , if the crash event
   * should not be recorded.
   */
  static sentry_value_t onCrash(const sentry_ucontext_t* uctx,
                                sentry_value_t event, void* closure);

  /**
   * @brief Send's a Sentry Event "envelope" to the Sentry endpoint.
   *
   * Will be used if NONE_TRANSPORT is enabled in cmake.
   * Will create a Task in the TaskSheudler to send that.
   *
   * @param envelope Envelope to be sent to sentry.
   * The transport takes ownership of the `envelope`, and must free it once it
   * is done.
   * @param state
   * If the transport requires state, such as an HTTP
   * client object or request queue, it can be specified in the `state`
   * parameter when configuring the transport. It will be passed as second
   * argument to this function. We are not using that.
   *
   */
  static void transportEnvelope(sentry_envelope_t* envelope, void* state);

 private:
  bool m_initialized = false;
  SentryAdapter();
};
#endif  // SENTRYADAPTER_H
