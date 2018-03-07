using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveAnimation : MonoBehaviour {
    [Header("References")]
    [SerializeField]
    private Renderer m_renderer;

    [Header("Options")]
    [SerializeField]
    private float m_waveSpeed1;
    [SerializeField]
    private float m_waveSpeed2;

    [Header("Debug")]
    [SerializeField]
    float offset1 = 0.0f;
    [SerializeField]
    float offset2 = 0.0f;

	// Use this for initialization
	void Start () {
		
	}

    private void FixedUpdate()
    {
        offset1 += m_waveSpeed1;
        offset2 += m_waveSpeed2;

        this.m_renderer.material.SetFloat("_OffsetX1", offset1);
        this.m_renderer.material.SetFloat("_OffsetX2", offset2);
    }
}
