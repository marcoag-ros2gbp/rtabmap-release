/*
Copyright (c) 2010-2014, Mathieu Labbe - IntRoLab - Universite de Sherbrooke
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Universite de Sherbrooke nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#ifndef UTIL2D_H_
#define UTIL2D_H_

#include <rtabmap/core/RtabmapExp.h>

#include <opencv2/core/core.hpp>
#include <rtabmap/core/Transform.h>

namespace rtabmap
{

namespace util2d
{

cv::Mat RTABMAP_EXP disparityFromStereoImages(
		const cv::Mat & leftImage,
		const cv::Mat & rightImage);

cv::Mat RTABMAP_EXP disparityFromStereoImages(
		const cv::Mat & leftImage,
		const cv::Mat & rightImage,
		const std::vector<cv::Point2f> & leftCorners,
		int flowWinSize = 9,
		int flowMaxLevel = 4,
		int flowIterations = 20,
		double flowEps = 0.02,
		float maxCorrespondencesSlope = 0.1f);

cv::Mat RTABMAP_EXP depthFromStereoImages(
		const cv::Mat & leftImage,
		const cv::Mat & rightImage,
		const std::vector<cv::Point2f> & leftCorners,
		float fx,
		float baseline,
		int flowWinSize = 9,
		int flowMaxLevel = 4,
		int flowIterations = 20,
		double flowEps = 0.02);

cv::Mat RTABMAP_EXP disparityFromStereoCorrespondences(
		const cv::Mat & leftImage,
		const std::vector<cv::Point2f> & leftCorners,
		const std::vector<cv::Point2f> & rightCorners,
		const std::vector<unsigned char> & mask,
		float maxSlope = 0.1f);

cv::Mat RTABMAP_EXP depthFromStereoCorrespondences(
		const cv::Mat & leftImage,
		const std::vector<cv::Point2f> & leftCorners,
		const std::vector<cv::Point2f> & rightCorners,
		const std::vector<unsigned char> & mask,
		float fx, float baseline);

float RTABMAP_EXP getDepth(
		const cv::Mat & depthImage,
		float x, float y,
		bool smoothing,
		float maxZError = 0.02f);

cv::Mat RTABMAP_EXP decimate(const cv::Mat & image, int d);

// Registration Depth to RGB
cv::Mat RTABMAP_EXP registerDepth(
		const cv::Mat & depth,
		const cv::Mat & depthK,
		const cv::Mat & colorK,
		const rtabmap::Transform & transform);

void RTABMAP_EXP fillRegisteredDepthHoles(
		cv::Mat & depth,
		bool vertical,
		bool horizontal,
		bool fillDoubleHoles = false);

} // namespace util3d
} // namespace rtabmap

#endif /* UTIL2D_H_ */
